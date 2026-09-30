# 单机部署：最简单的太一使用方式

适用版本：**v3.8.0**，复核日期：**2026-09-30**。如果尚未需要多台流量节点或主机故障容错，建议从一台太一开始。一个 `tiyi run` 进程包含 Controller、管理控制台和内置 Agent/数据面；安装后一起启动，无须单独注册 Agent，也不需要远端节点许可。

```text
访客 ── HTTP/HTTPS ──> 太一服务器 ──> 应用源站
                       ├─ Controller + 管理控制台
                       └─ 内置 Agent：TLS、代理、WAF
管理员 ──────────────> 管理控制台 / 本机 CLI
```

这是推荐的快速入门方式，也适合能接受维护窗口的小规模业务。整台服务器属于同一个故障域：主机或进程中断会同时影响业务流量和管理。业务不能接受这一点时，转向[集群部署](cluster-deployment.md)。

<a id="install"></a>
## 1. 在新的 Linux 主机安装

准备 Linux amd64/arm64、持久磁盘、sudo、systemd，以及本机可达的应用源站。预留网站端口 **80/443**、管理端口 **8080**。已有服务占用端口时，使用[自定义端口](getting-started.md#custom-ports)或[已有 Nginx 网站接入教程](https://www.tiyisec.com/zh/docs/existing-site.html)。

在太一主机执行，固定到本指南对应版本：

```sh
curl -fsSL https://www.tiyisec.com/install.sh | TIYI_VERSION=v3.8.0 bash
sudo tiyi install --now
tiyi --version
sudo tiyi system health
```

安装器校验签名二进制；`install --now` 创建 systemd 服务、设置开机自启并启动。保存终端显示的一次性管理员密码。版本应为 v3.8.0，健康检查应显示实例正常；配置 TLS 站点和证书后才会启动 HTTPS。

已有安装请使用[升级与迁移](upgrade-migration.md)。离线和前台方式见[安装指南](installation.md)。

<a id="first-site"></a>
## 2. 登录并接入第一个站点

浏览器打开 `http://服务器IP:8080`，将“服务器IP”换成太一主机的实际地址。用 **admin** 登录，然后修改初始密码。首次管理入口只允许管理网络访问。

需要快速演练时，在太一主机的第二个终端执行：

```sh
mkdir -p "$HOME/tiyi-demo"
printf 'Hello from the origin\n' > "$HOME/tiyi-demo/index.html"
python3 -m http.server 9000 --bind 127.0.0.1 --directory "$HOME/tiyi-demo"
```

保持该终端运行，再在同一主机的另一个终端执行：

```sh
sudo tiyi site create --name quickstart --host quickstart.test \
  --upstream-url http://127.0.0.1:9000 --tls none
```

站点默认使用内置 Light WAF 策略，下面的检查不需要为 `quickstart.test` 修改 DNS。接入真实应用时，在 **应用交付 → 站点 → 创建** 填写实际域名和可达源站，按[证书操作](operations.md#https)配置 HTTPS。源站 URL 应指向应用本身，不能指回站点对外的太一地址。

<a id="verify"></a>
## 3. 验证访问与防护

在太一主机向演练站点发送请求：

```sh
# 正常请求：200，正文为 Hello from the origin
curl -i -H 'Host: quickstart.test' http://127.0.0.1/

# 受控 SQL 注入探针：默认阻断策略应返回 403
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/

# 正常访问仍应成功
curl -i -H 'Host: quickstart.test' http://127.0.0.1/
```

在总览与 **日志 → 攻击日志** 查看结果，响应包含 `X-Request-Id` 时用它定位请求。站点保存成功或进程健康，不能单独证明源站可达或 WAF 已阻断；结果不符时参见[排障](troubleshooting.md)。

演练结束后删除 `quickstart` 站点，停止 Python 终端。太一可以继续运行，接入自己的应用。

<a id="production"></a>
## 4. 单机上线前的准备

- 切换公网 DNS 前配置业务域名、证书与 HTTPS。源站保持私有，只允许太一访问应用入口；用真实应用验证登录、回调、WebSocket、上传和普通请求。
- 给控制台配置独立 HTTPS 管理地址，启用 `auth.refresh_cookie_secure: true`，限制为管理员访问，并保留 SSH/本地 CLI 恢复入口。独立 HTTPS 网关可以避免管理入口依赖业务站点健康；参见[管理入口](deployment.md#management)。
- `/var/lib/tiyi` 使用持久磁盘，保留 KEK 和配置，设置可承担的日志/证据配额。监控磁盘、CPU、内存、源站故障、证书到期和观测投递；采用[仅导出指标的方式](operations.md#prometheus)。
- 前面已有 CDN/代理时，配置[经过验证的客户端 IP 提取](deployment.md#client-ip)，限制绕过入口的直连，并验证伪造转发头不能替换真实客户端地址。
- 从默认策略开始，以真实流量检查误报。详细证据可能被采样或过期；HTTP 结果与完整计数各有用途。
- 做一致[备份](upgrade-migration.md#backup)，演练同版本恢复。冷备、重启和不兼容升级应安排流量中断窗口；站点导出不能代替整套安装备份。

用实际规则、TLS、请求大小和证据保留测量容量。本指南不承诺通用 CPU/内存配置或 QPS。

<a id="grow"></a>
## 5. 按业务需求扩展

已有 CDN/LB 可以放在单台太一前面，但一个节点仍只有一个主机故障域。需要节点冗余或更高容量时，注册远端 Agents，把它们的业务监听放到外部高可用 LB 后面。Controller 仍只有一个可写实例，单独规划恢复。

继续阅读[集群部署：一个 Controller、多台 Agents 与负载均衡](cluster-deployment.md)，完成注册、TLS、健康检查、真实客户端 IP、滚动维护与故障验收。
