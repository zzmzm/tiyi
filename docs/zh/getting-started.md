# Tiyi 快速开始

Tiyi 是一个单可执行文件、可自托管、内置 WAF 的反向代理，并集成了管理平面。

## 1. 安装

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash
```

安装脚本会自动识别平台（Linux amd64/arm64），解析最新的已签名发行版，完成校验后
将 `tiyi` 安装到 `/usr/local/bin`。同一脚本也镜像在
`https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh`。

指定版本或更改安装目录：

```sh
TIYI_VERSION=v3.0.0 TIYI_PREFIX="$HOME/.local/bin" \
  bash -c "$(curl -fsSL https://www.tiyisec.com/install.sh)"
```

## 2. 手动校验下载（可选）

每个发行版都附带 `SHA256SUMS`、`SHA256SUMS.sig` 以及对应平台的压缩包。先校验
SHA-256：

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

如需使用 OpenSSL 3.x 校验校验和文件的 Ed25519 签名，请先用已发布的原始公钥
（`release-key.pub`）构建 PEM：

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

单机安装会在一个进程中同时运行服务端、agent 和仪表盘。默认情况下 Tiyi 把状态
存放在 `/var/lib/tiyi` 并监听 80/443 端口，因此默认方式需要 root：

```sh
sudo tiyi standalone
```

首次启动时，Tiyi 会自动创建 `admin` 账户，并向控制台打印一次性随机密码 —— 请在
它滚走之前复制下来（它仅以哈希形式存储）。打开 `http://127.0.0.1:8080`，用
`admin` 登录，并添加第一个站点。完整的运维流程（配置文件、管理套接字、站点、
上游、证书、WAF 策略）见 <https://www.tiyisec.com/zh/docs/>。

若要以普通用户身份（不用 `sudo`）运行，把 Tiyi 指向可写路径并使用高端口 ——
下面的进阶命令正是这么做的。

### 进阶：以普通用户运行 / 自定义管理员密码

用于自动化、容器镜像、CI，或只是想不用 `sudo` 运行时，把 Tiyi 指向可写路径并
使用高端口（并可选地设定管理员密码）—— 一条命令搞定。这里不涉及
`/var/lib/tiyi`，也不绑定 80/443 端口，因此无需 root：

```sh
mkdir -p /tmp/waf
TIYI_BOOTSTRAP_ADMIN_PASSWORD='admin123@xxxxxxm' \
  tiyi standalone \
  --addr 0.0.0.0:8080 \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443 \
  --admin-socket /tmp/waf/admin.sock
```

Tiyi 会原样采用所给凭据且不打印任何 banner。用户名默认 `admin`。仅当尚不存在
任何用户时才会自动生成密码，因此重启都是空操作。忘了密码？在同一台主机上通过
本地管理套接字重置 —— 无需登录：

```sh
tiyi user list
tiyi user reset-password <user-id> --password <new-password>
```

## 4. 保持更新

```sh
tiyi self-update --check     # 是否有更新的已签名发行版？
tiyi self-update --yes       # 下载、校验并安装
```

`self-update` 会在替换磁盘上的二进制之前，针对内嵌于二进制中的发布公钥校验
SHA-256 与 Ed25519 签名。更新后请**重启服务**。使用 `--channel prerelease`
可跟踪预发布版本。

## 5. 授权

Tiyi 在单节点上免费且功能完整。扩展到多节点（远程 agent）时使用签名授权许可 ——
单节点体验保持不变。详见 [EULA.md](../../EULA.md)。

## 支持

安全问题请按照 [SECURITY.md](../../SECURITY.md) 私下报告；其他问题请在分发仓库
提交 issue。
