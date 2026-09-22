# 快速开始

用几分钟，从一台干净的 Linux 主机走到太一拦截真实攻击。我们会安装太一、打开控制台、创建一个站点，再用几个请求看看 WAF 如何保护它。

<a id="prerequisites"></a>

## 前置条件

- 一台 **Linux amd64 或 arm64** 主机。默认安装使用 sudo 和 systemd。
- 在线安装需要 **curl、tar、sha256sum**，以及可访问发行包的网络。
- 一个太一能访问的 HTTP 后端。没有现成应用也没关系，下面用 Python 3 启动一个演示后端。

本页默认使用网站端口 **80 / 443** 和管理端口 **8080**。需要[手动分步骤](#manual)、[自定义端口](#custom-ports)或[离线安装](#offline)，可以直接跳到相应段落。

> **已有太一安装？** 请先阅读[升级与迁移](upgrade-migration.md)。下面的安装命令用于新主机。

<a id="install"></a>
<a id="one-line"></a>

## 1. 安装并启动太一

在太一主机执行：

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

前半段下载并校验最新稳定版二进制，安装到 `/usr/local/bin`；后半段安装 systemd 服务，立即启动并设置开机自启。
网站默认使用 **80 / 443**，控制台使用 **8080**。HTTPS 会在配置 TLS 站点和证书后提供服务；此时还没有 443 监听是正常的。

首次安装会在当前终端打印登录信息，密码以实际输出为准：

```text
Tiyi administrator created
  username:  admin
  password:  <your-generated-one-time-password>
```

用下面两条命令确认版本与运行状态：

```sh
tiyi --version
sudo tiyi system health
```

启动失败时，运行 `sudo journalctl -u tiyi -n 100 --no-pager`，对照[排障指南](troubleshooting.md)。没有 systemd 的主机见[前台运行](installation.md#foreground)。

<a id="run"></a>
<a id="login"></a>

## 2. 打开控制台

在浏览器打开 `http://服务器IP:8080`，将“服务器IP”换成安装太一的主机 IP。
太一默认监听 `0.0.0.0:8080`。使用 **admin** 和安装时终端显示的密码登录，即可进入总览，查看流量与防护结果。

如果页面打不开，检查服务是否已启动，以及服务器防火墙或云安全组是否允许访问 8080 端口。

> **首次密码只显示一次。** 登录后修改密码；若丢失，可在太一主机[通过本机 CLI 重置](troubleshooting.md#reset-password)，不需要删除数据库。

<a id="upstream"></a>

## 3. 准备一个后端

在太一主机另开一个终端，启动一个简单的 HTTP 服务：

```sh
mkdir -p "$HOME/tiyi-demo"
printf 'Hello from the origin\n' > "$HOME/tiyi-demo/index.html"
python3 -m http.server 9000 --bind 127.0.0.1 --directory "$HOME/tiyi-demo"
```

保持这个终端运行。已有应用时，直接使用它的源站地址即可；下一步把 `http://127.0.0.1:9000` 换成太一主机能访问的 URL。
演示后端只监听本机，不需要对外放行 9000。

<a id="site"></a>

## 4. 创建第一个站点

回到太一主机的另一个终端。CLI 通过本地管理通道连接系统服务，不需要先登录或获取 token：

```sh
sudo tiyi site create --name quickstart --host quickstart.test \
  --upstream-url http://127.0.0.1:9000 --tls none
```

站点创建后立即启用，默认使用内置 **Light** WAF 策略。也可以在控制台 **应用交付 → 站点 → 新建** 中填入相同的名称、域名与上游地址，关闭 TLS，保留 WAF 和 Light 策略后保存；两种方式选一种即可。

`quickstart.test` 只是这个演示的域名，下面的请求会直接指定它，不需要修改 DNS。用真实域名上线时，再配置证书和 HTTPS。

主机名和别名都支持 `*.example.com`，只匹配 `api.example.com` 这样的一级子域名，不包含 `example.com` 或 `a.b.example.com`；需要根域名时单独添加。具体填写、证书和 API 绑定限制见[通配域名建站](operations.md#wildcard-hosts)。

<a id="verify"></a>

## 5. 验证 WAF 拦截攻击

在太一主机先发一个正常请求，再向刚创建的演示站点发三个常见攻击。每条命令只打印 HTTP 状态码，注释中标出了预期结果：

```sh
# 正常请求 → 200
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H 'Host: quickstart.test' http://127.0.0.1/

# SQL 注入 → 403
curl -sS -o /dev/null -w '%{http_code}\n' --get \
  -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/

# XSS → 403
curl -sS -o /dev/null -w '%{http_code}\n' --get \
  -H 'Host: quickstart.test' \
  --data-urlencode 'q=<script>alert(1)</script>' http://127.0.0.1/

# 路径穿越 → 403；--path-as-is 保留原始路径，避免 curl 提前归一化
curl -sS -o /dev/null -w '%{http_code}\n' --path-as-is \
  -H 'Host: quickstart.test' http://127.0.0.1/../../../../etc/passwd
```

再发一次正常请求，仍应返回 **200**。想看正文和响应头时，将 `-sS -o /dev/null -w '%{http_code}\n'` 换成 `-i`：正常请求会显示 `Hello from the origin`；攻击响应中的 `X-Request-Id` 可以用来查找对应日志。

回到控制台，在总览查看流量与处理结果，在 **日志 → 攻击日志** 查看命中规则。明细是否保留、何时可见取决于日志和采样设置，先以实际 HTTP 响应确认拦截。
若返回 502，先检查后端是否仍在运行；若攻击未被拦截，检查站点 WAF 开关、策略模式和例外设置，见[排障指南](troubleshooting.md)。

<a id="alternatives"></a>

## 其他安装方式

以下方式与第一步的一行安装任选其一。完成安装并启动服务后，从[打开控制台](#login)继续。

<a id="manual"></a>

### 手动分步骤安装

想先检查脚本，再分别安装二进制和启动服务，可以这样做：

```sh
curl -fsSL https://www.tiyisec.com/install.sh -o /tmp/tiyi-install.sh
less /tmp/tiyi-install.sh
bash /tmp/tiyi-install.sh
tiyi --version
sudo tiyi doctor
sudo tiyi install --now
```

`less` 中按 `q` 退出；没有 less 时可用 `cat`。运行脚本只安装二进制，最后一行才启动服务并打印首次密码。
固定版本时，将运行脚本的一行换成 `TIYI_VERSION=vX.Y.Z bash /tmp/tiyi-install.sh`，使用已发布的版本标签。
安装目录、Gitee 镜像和校验方式见[安装参考](installation.md#prebuilt)。

<a id="custom-ports"></a>

### DIY：自定义端口

如果 80、443 或 8080 已被其他服务占用，可以先写配置再启动。下面以新安装为例，将管理端口改成 **8081**，网站端口改成 **8180 / 18443**：

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8081"
proxy:
  http_addr: ":8180"
  https_addr: ":18443"
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi install --now
```

不带 `--now` 的 `install` 只准备系统服务，暂不启动。启动后，在浏览器打开 `http://服务器IP:8081`，使用太一主机的实际 IP。
后面的测试 URL 改为 `http://127.0.0.1:8180/`，演示后端仍使用 9000。
已有配置时保留其他字段，只修改需要的监听地址，见[端口与启动配置](configuration.md#ports)。

<a id="offline"></a>

### 离线安装

在联网电脑下载与目标主机架构匹配的发行包、同版本的 `SHA256SUMS`、`SHA256SUMS.sig` 和官方 `release-key.pub`，一起复制到离线主机。
按[离线安装完整步骤](installation.md#offline)核验签名和校验和，再解包安装。离线主机无需运行在线 `install.sh`。

安装好二进制和离线配置后，仍用同一条命令启动系统服务：

```sh
sudo tiyi install --now
```

需要自定义端口时，在启动前写入上面的 YAML。内置 WAF 规则可直接使用；HTTPS 使用上传的证书，公网证书申请和外部订阅需要另外准备网络连接。

<a id="next"></a>

## 下一步阅读

- [实战与进阶](practice.md)：沿着这个演示站点，继续练观察与阻断、规则调优、API 校验和自动化。
- [日常运维](operations.md)：接入真实域名与 HTTPS，配置源站、路由和告警。
- [配置与模板](configuration.md)：复制启动配置和建站 YAML；已有站点也可[导入与导出](site-import.md)。
- [工作方式](concepts.md)与 [CLI 参考](cli.md)：理解站点、策略等概念，查找更多操作。

体验结束后，在站点页删除 `quickstart`，并在演示后端终端按 Ctrl+C。太一服务可以保留，继续接入自己的应用。
