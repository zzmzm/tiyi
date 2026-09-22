# 安装与服务管理

本页解决如何安装、校验下载、离线部署和管理服务。第一次使用可跟随[快速开始](getting-started.md)继续登录、建站与验证。
适用 Linux amd64/arm64。安装脚本用于新主机；已有安装请走[升级与迁移](upgrade-migration.md)。

<a id="prebuilt"></a>
## 1. 默认安装：系统服务与 80/443/8080

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

需要 curl、tar、sha256sum；默认安装到 `/usr/local/bin` 需要 root 或 sudo，服务方式需要 systemd。
脚本下载二进制并检查环境；`tiyi install --now` 创建非 root 服务账号、启动服务并设为开机自启。
首次管理员密码显示在执行安装命令的终端。若 sudo 的 PATH 不含 `/usr/local/bin`，用完整路径执行。
已是 root 且没有 sudo 时省略 sudo。无 systemd 或无 root 的环境见[前台运行](#foreground)。

| 默认入口 | 用途 | 安装后要做什么 |
|---|---|---|
| `0.0.0.0:8080` | 控制台与管理 API | 浏览器访问 `http://服务器IP:8080`，向管理网络放行 8080 |
| `:80` | 网站 HTTP / ACME HTTP-01 | 添加站点和源站；按域名访问 |
| `:443` | 网站 HTTPS | 配置 TLS 站点和覆盖域名的证书后提供 HTTPS |

安装器不会修改防火墙、云安全组或 DNS，也不会接管已有 Nginx/Apache 的端口。
没有 TLS 站点时 443 可能尚未监听；打开控制台不代表业务已受保护。

## 2. 手动分步骤与自定义安装

```sh
curl -fsSL https://www.tiyisec.com/install.sh -o /tmp/tiyi-install.sh
less /tmp/tiyi-install.sh
bash /tmp/tiyi-install.sh
/usr/local/bin/tiyi --version
sudo /usr/local/bin/tiyi doctor
sudo /usr/local/bin/tiyi install --now
```

`less` 按 `q` 退出，也可用 `cat` 阅读。希望修改端口时先停在最后一步之前，按[DIY 安装](getting-started.md#custom-ports)写入 YAML 再启动。
`sudo tiyi install` 不带 `--now` 只创建 unit，不启动也不设为开机启动；首次启动仍执行 `install --now`，让密码显示在当前终端。

<a id="mirrors"></a>
### 镜像、指定版本与安装目录

中国大陆可使用 Gitee：

```sh
curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh -o /tmp/tiyi-install.sh
TIYI_MIRROR=gitee bash /tmp/tiyi-install.sh
sudo /usr/local/bin/tiyi install --now
```

默认下载先尝试 GitHub，失败或过慢时回退到 Gitee。同一脚本也在 GitHub 分发仓库的 `install.sh`。
要固定版本或装到用户目录，先下载脚本，再运行下面的替代命令；将版本换为选定的已发布标签：

```sh
mkdir -p "$HOME/.local/bin"
TIYI_VERSION=vX.Y.Z TIYI_PREFIX="$HOME/.local/bin" bash /tmp/tiyi-install.sh
export PATH="$HOME/.local/bin:$PATH"
```

用户目录适合前台试用。systemd 服务启用了 `ProtectHome`，正式服务使用 `/usr/local/bin/tiyi`。

| 安装器变量 | 默认值 | 用途 |
|---|---|---|
| `TIYI_MIRROR` | `auto` | `auto`、`github` 或 `gitee` |
| `TIYI_VERSION` | 最新稳定版 | 选择已发布发行标签 |
| `TIYI_PREFIX` | `/usr/local/bin` | 二进制安装目录，先确保目录存在 |
| `TIYI_REPO` | `zzmzm/tiyi` | GitHub 分发仓库 |
| `TIYI_GITEE_REPO` | `tiyisec/tiyi` | Gitee 分发仓库 |

安装器**必做 SHA-256 校验**；具备支持 `pkeyutl -rawin` 的 OpenSSL、xxd 和签名文件时还会验证 Ed25519。
缺少签名验证条件会明确提示跳过，不能把 SHA-256 通过当作签名验证通过。要求完整核验时使用下方流程。

<a id="offline"></a>
## 3. 离线安装：下载、核验、安装、启动

### 在联网电脑准备文件

从 [GitHub Releases](https://github.com/zzmzm/tiyi/releases) 或 [Gitee Releases](https://gitee.com/tiyisec/tiyi/releases)
选择已发布且计划安装的版本。在**目标离线主机**执行 `uname -m` 确认架构：`x86_64` 用 amd64，`aarch64` 用 arm64。
下面在联网电脑下载；先替换 `vX.Y.Z` 和架构：

```sh
# 先替换为已发布版本，并选择离线目标主机的架构
TIYI_RELEASE='vX.Y.Z'
TIYI_ARCH='amd64'  # x86_64 用 amd64；aarch64 用 arm64
TIYI_ARCHIVE="tiyi_${TIYI_RELEASE#v}_linux_${TIYI_ARCH}.tar.gz"
mkdir -p tiyi-offline
cd tiyi-offline
TIYI_RELEASE_URL="https://github.com/zzmzm/tiyi/releases/download/${TIYI_RELEASE}"
curl -fL "$TIYI_RELEASE_URL/$TIYI_ARCHIVE" -o "$TIYI_ARCHIVE"
curl -fL "$TIYI_RELEASE_URL/SHA256SUMS" -o SHA256SUMS
curl -fL "$TIYI_RELEASE_URL/SHA256SUMS.sig" -o SHA256SUMS.sig
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/release-key.pub -o release-key.pub
```

也可在发行页面手动下载这四个文件。Gitee 下载前缀为
`https://gitee.com/tiyisec/tiyi/releases/download/所选标签`，公钥在分发仓库根目录。
把整个目录通过可信介质复制到离线主机；包、清单、签名必须来自同一版本。
目标机预先准备 tar、sha256sum、base64、xxd 和支持 Ed25519 / `pkeyutl -rawin` 的 OpenSSL，可通过发行版的离线软件包安装。

<a id="verify-download"></a>
### 在离线主机核验并安装二进制

进入刚复制的目录，将压缩包名称替换为实际文件名后执行整段。先验证官方公钥与清单签名，再检查该压缩包的 SHA-256；任一步失败都停止安装。
此流程也适用于联网环境的手工下载校验。

```sh
# 替换为复制到本机的准确压缩包文件名
TIYI_ARCHIVE='tiyi_X.Y.Z_linux_amd64.tar.gz'
(
  set -eu
  # 核对官方 Ed25519 公钥，不接受压缩包附带的其他公钥
  test "$(tr -d '\r\n' < release-key.pub)" = 'RIH4Xm2V8NjU4byn/xq+36xQG38dWQ9eQB39Bk+Aze4='
  { printf '302a300506032b6570032100'; base64 -d release-key.pub | xxd -p -c 256; } \
    | xxd -r -p | base64 > release-key.der.b64
  { echo '-----BEGIN PUBLIC KEY-----'; cat release-key.der.b64; echo '-----END PUBLIC KEY-----'; } \
    > release-key.pem
  base64 -d SHA256SUMS.sig > SHA256SUMS.sig.bin
  openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
    -in SHA256SUMS -sigfile SHA256SUMS.sig.bin
  # 校验清单必须恰好包含一个目标压缩包条目
  awk -v file="$TIYI_ARCHIVE" '$2 == file || $2 == "*" file' SHA256SUMS > selected.sha256
  test "$(wc -l < selected.sha256)" -eq 1
  sha256sum --check selected.sha256
  mkdir -p tiyi-release
  tar -xzf "$TIYI_ARCHIVE" -C tiyi-release tiyi
  sudo install -m 0755 tiyi-release/tiyi /usr/local/bin/tiyi
)
```

预期看到 `Signature Verified Successfully` 和目标压缩包的 `OK`，且整段命令成功退出。
若公钥不匹配、签名失败、文件缺失或校验和不符，重新核对下载版本与官方文件，不继续执行服务安装。

### 配置离线运行并启动

核验安装成功后，在新主机创建服务但先不启动：

```sh
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8080"
geo:
  auto_update: false
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi install --now
sudo tiyi system health
```

需要其他端口时，在启动前加上[代理端口配置](configuration.md#ports)。浏览器访问 `http://服务器IP:8080` 登录，使用离线主机在当前网络可达的 IP。
内置 CRS 和本地源站无需联网。HTTPS 使用上传证书；需要国家/ASN 数据时从系统设置上传 MMDB。
ACME、外部 IP 订阅、通知和 AI 仍需各自的外部连接；按实际网络配置这些功能。
继续[快速开始的源站与建站步骤](getting-started.md)，完成正常请求和拦截验证。

<a id="foreground"></a>
## 4. 前台或无 root 试用

先将二进制安装在自己的可写目录。状态用持久磁盘目录；控制台使用 8080，本机网站测试使用高端口：

```sh
mkdir -p "$HOME/.local/share/tiyi-demo"
"$HOME/.local/bin/tiyi" run --addr 0.0.0.0:8080 \
  --state-db "$HOME/.local/share/tiyi-demo/state.db" \
  --admin-socket "$HOME/.local/share/tiyi-demo/admin.sock" \
  --caddy-admin-socket "$HOME/.local/share/tiyi-demo/caddy.sock" \
  --proxy-http-addr 127.0.0.1:8180 \
  --proxy-https-addr 127.0.0.1:18443
```

保持终端运行；首次密码在这里显示。Ctrl+C 停止进程，数据仍保留；重新运行同一命令恢复。
另开终端执行 CLI 时传入实际 socket：

```sh
"$HOME/.local/bin/tiyi" --admin-socket "$HOME/.local/share/tiyi-demo/admin.sock" system health
```

浏览器访问 `http://服务器IP:8080`，使用太一主机的实际 IP。网站测试在太一主机执行，请求 `http://127.0.0.1:8180/`。
无 systemd 的正式部署可由已有进程管理器管理 `tiyi run`，自行配置运行账号、开机启动和重启策略。

<a id="service"></a>
## 5. 日常服务管理与文件位置

| 要做什么 | 命令 |
|---|---|
| 查看开机启动与进程 | `sudo systemctl is-enabled tiyi` · `sudo systemctl status tiyi --no-pager` |
| 查看最近启动错误 | `sudo journalctl -u tiyi -n 100 --no-pager` |
| 暂停 / 恢复已有服务 | `sudo systemctl stop tiyi` · `sudo systemctl start tiyi` |
| 修改启动配置后重启 | `sudo systemctl restart tiyi` |
| 查看应用健康 | `sudo tiyi system health` |
| 移除服务，保留数据 | `sudo tiyi uninstall` |

停止单节点服务会中断该节点承载的业务；先安排切流或维护窗口。站点、策略等 UI/CLI/API 变更通常直接发布，无需重启。

| 路径 | 内容 / 备份要求 |
|---|---|
| `/usr/local/bin/tiyi` | 二进制；备份时记录版本，保留匹配的旧二进制 |
| `/etc/tiyi/tiyi.yaml` | 可选启动配置；未创建时使用内置默认值 |
| `/etc/tiyi/tiyi.env` | 可选 systemd 环境变量和秘密；限制读取并纳入备份 |
| `/var/lib/tiyi/` | 完整持久状态、证书、默认 KEK 和数据；一致备份整个目录 |
| `/run/tiyi/` | 运行时 socket；进程启动时重建，不作为恢复数据 |

`tiyi update` 只替换二进制，不重启服务或转换不兼容状态。[升级与迁移](upgrade-migration.md)包含备份与恢复步骤。
`uninstall --purge` 会删除状态和配置；它不是日常重启、升级或找回密码的方法。

## 6. 运行时环境变量

持久化服务配置优先写入 `tiyi.yaml`。只有当 service manager、容器运行时或
密钥管理器需要在运行时注入配置时，才使用环境变量。环境变量名与配置键一一对应：
加 `TIYI_` 前缀，转为大写，并把点替换为下划线。例如 `auth.jwt_secret`
对应 `TIYI_AUTH_JWT_SECRET`。

文件配置请从[完整注释版 `tiyi.yaml` 模板](templates/tiyi.yaml)开始；其中包含
当前全部进程配置键、安全文件说明，以及配套的[安装/校验步骤](configuration.md)。

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
