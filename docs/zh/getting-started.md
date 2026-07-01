# 太一快速开始

太一是一个单可执行文件、可自托管、内置 WAF 的反向代理，并集成了管理平面。

## 1. 安装

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash
```

安装脚本会自动识别平台（Linux amd64/arm64），解析最新的已签名发行版，完成校验后
将 `tiyi` 安装到 `/usr/local/bin`。同一脚本也镜像在
`https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh`，中国大陆镜像在
`https://gitee.com/tiyisec/tiyi/raw/main/install.sh`。

默认安装器先尝试 GitHub，失败或过慢时回退到 Gitee Release 镜像。必要时可强制
使用 Gitee：

```sh
curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh | TIYI_MIRROR=gitee bash
```

指定版本或更改安装目录：

```sh
TIYI_VERSION=v3.0.3 TIYI_PREFIX="$HOME/.local/bin" \
  bash -c "$(curl -fsSL https://www.tiyisec.com/install.sh)"
```

安装器环境变量：

| 变量 | 默认值 | 含义 |
|---|---|---|
| `TIYI_MIRROR` | `auto` | 下载来源：`auto`（GitHub 优先，Gitee 回退）、`github` 或 `gitee`。 |
| `TIYI_REPO` | `zzmzm/tiyi` | 安装器使用的 GitHub `owner/name`。 |
| `TIYI_GITEE_REPO` | `tiyisec/tiyi` | 安装器使用的 Gitee `owner/name`。 |
| `TIYI_VERSION` | 最新稳定版 | 固定发行标签，例如 `v3.0.3`。 |
| `TIYI_PREFIX` | `/usr/local/bin` | `tiyi` 二进制安装目录。 |

## 2. 手动校验下载（可选）

每个发行版都附带 `SHA256SUMS`、`SHA256SUMS.sig` 以及对应平台的压缩包。先校验
SHA-256：

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

如需校验校验和文件的 Ed25519 签名，请使用支持 `pkeyutl -rawin` 的 OpenSSL，
并先用已发布的原始公钥（`release-key.pub`）构建 PEM：

```sh
{ printf '302a300506032b6570032100'; base64 -d release-key.pub | xxd -p -c 256; } \
  | xxd -r -p | base64 > /tmp/k.b64
{ echo "-----BEGIN PUBLIC KEY-----"; cat /tmp/k.b64; echo "-----END PUBLIC KEY-----"; } \
  > release-key.pem

openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
  -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

其中 `302a300506032b6570032100` 是固定的 Ed25519 SubjectPublicKeyInfo 头部；
已发布的公钥即 32 字节原始公钥的 base64 形式。

## 3. 运行

单机安装会在一个进程中同时运行服务端、agent 和仪表盘。默认情况下太一把状态
存放在 `/var/lib/tiyi` 并监听 80/443 端口，因此默认方式需要 root：

```sh
sudo tiyi standalone || sudo /usr/local/bin/tiyi standalone
```

首次启动时，太一会自动创建 `admin` 账户，并向控制台打印一次性随机密码 —— 请在
它滚走之前复制下来（它仅以哈希形式存储）。打开 `http://127.0.0.1:8080`，用
`admin` 登录，并添加第一个站点。完整的运维流程（配置文件、管理套接字、站点、
上游、证书、WAF 策略）见 <https://www.tiyisec.com/zh/docs/>。

若要以普通用户身份（不用 `sudo`）运行，把太一指向可写路径并使用高端口 ——
下面的进阶命令正是这么做的。

### 进阶：以普通用户运行 / 自定义管理员密码

用于自动化、容器镜像、CI，或只是想不用 `sudo` 运行时，把太一指向可写路径并
使用高端口（并可选地设定管理员密码）—— 一条命令搞定。这里不涉及
`/var/lib/tiyi`，也不绑定 80/443 端口，因此无需 root：

```sh
mkdir -p /tmp/waf
TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD='admin123@xxxxxxm' \
  tiyi standalone \
  --addr 0.0.0.0:8080 \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443 \
  --admin-socket /tmp/waf/admin.sock
```

太一会原样采用所给凭据且不打印任何 banner。用户名默认 `admin`。仅当尚不存在
任何用户时才会自动生成密码，因此重启都是空操作。忘了密码？在同一台主机上通过
本地管理套接字重置 —— 无需登录：

```sh
tiyi user list
tiyi user reset-password <user-id> --password <new-password>
```

## 4. 通过环境变量配置运行时（可选）

持久化服务配置优先写入 `server.yaml`。只有当 service manager、容器运行时或
密钥管理器需要在运行时注入配置时，才使用环境变量。环境变量名与配置键一一对应：
加 `TIYI_` 前缀，转为大写，并把点替换为下划线。例如 `auth.jwt_secret`
对应 `TIYI_AUTH_JWT_SECRET`。

常用配置覆盖：

| 变量 | 配置键 | 适用场景 |
|---|---|---|
| `TIYI_SERVER_ADDR` | `server.addr` | 把 API / 控制台绑定到不同地址。 |
| `TIYI_STORE_STATE_DB` | `store.state_db` | 移动 SQLite 状态数据库。 |
| `TIYI_LOG_LEVEL` | `log.level` | 临时调整进程日志级别。 |
| `TIYI_PROXY_HTTP_ADDR` | `proxy.http_addr` | 修改 HTTP 数据面监听地址。 |
| `TIYI_PROXY_HTTPS_ADDR` | `proxy.https_addr` | 修改 HTTPS 数据面监听地址。 |
| `TIYI_PROXY_CADDY_ADMIN_SOCKET` | `proxy.caddy_admin_socket` | 移动内嵌 Caddy admin socket。 |
| `TIYI_CRYPTO_KEK_FILE` | `crypto.kek_file` | 为生产环境固定静态加密 KEK 路径。 |
| `TIYI_AUTH_JWT_SECRET` | `auth.jwt_secret` | 为生产环境设置稳定 JWT 签名密钥。 |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_USERNAME` | `auth.bootstrap_admin_username` | 指定首个管理员用户名。 |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` | `auth.bootstrap_admin_password` | 为自动化指定首个管理员密码。 |
| `TIYI_LICENSE_KEY_PATH` | `license.key_path` | 启动时加载签名 license 文件。 |
| `TIYI_UPDATE_REPO` | `update.repo` | 覆盖更新检查使用的 GitHub release 仓库。 |
| `TIYI_UPDATE_CHANNEL` | `update.channel` | 为 `tiyi update` 使用 `stable` 或 `prerelease`。 |
| `TIYI_UPDATE_MIRROR` | `update.mirror` | 更新检查/下载使用 `auto`、`github` 或 `gitee`。 |

较少使用的配置键也遵循同一规则。LDAP/RADIUS、token 生命周期、cookie 设置与
认证后端细项优先写 YAML，除非部署平台必须通过环境变量注入。

## 5. 保持更新

```sh
tiyi update --check          # 是否有更新的已签名发行版？
tiyi update --yes            # 下载、校验并安装
tiyi update --yes --mirror gitee
```

`update` 会在替换磁盘上的二进制之前，针对内嵌于二进制中的发布公钥校验
SHA-256 与 Ed25519 签名。更新后请**重启服务**。使用 `--channel prerelease`
可跟踪预发布版本。

更新环境变量：

| 变量 | 默认值 | 含义 |
|---|---|---|
| `TIYI_UPDATE_MIRROR` | `auto` | 更新检查/下载来源：`auto`、`github` 或 `gitee`。 |
| `TIYI_UPDATE_REPO` | `zzmzm/tiyi` | `github` 与 `auto` 使用的 GitHub `owner/name`。 |
| `TIYI_UPDATE_CHANNEL` | `stable` | `stable` 或 `prerelease`。 |

## 6. 授权

太一在单节点上免费且功能完整。扩展到多节点（远程 agent）时使用签名授权许可 ——
单节点体验保持不变。详见 [EULA.md](../../EULA.md)。

## 支持

安全问题请按照 [SECURITY.md](../../SECURITY.md) 私下报告；其他问题请在分发仓库
提交 issue。
