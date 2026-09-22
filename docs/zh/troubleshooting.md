# 排障

按从外到内的顺序诊断：进程、监听、站点匹配、路由、WAF、上游。每次只改变一层，
并保留失败请求的 ID。

## 先按现象定位

| 现象 | 先查什么 | 接下来做什么 |
|---|---|---|
| `sudo: tiyi: command not found` | `/usr/local/bin/tiyi --version` | 用 `sudo /usr/local/bin/tiyi …`，核对 sudo PATH |
| `address already in use` | `sudo ss -ltnp`、`sudo tiyi doctor` | 找到占用者；按[端口指南](configuration.md#ports)调整，不直接停掉未知业务 |
| 安装后没有 443 监听 | 是否有已启用的 TLS 站点和证书 | 按[HTTPS 步骤](operations.md#https)配置；仅管理页启动不会建立 HTTPS 网站 |
| 浏览器打不开控制台 | 服务器 IP、管理监听、防火墙或安全组 | 访问 `http://服务器IP:8080`；用 `sudo ss -ltnp` 核对默认监听 `0.0.0.0:8080`，确认 8080 端口可达 |
| 本机 CLI `permission denied` | 系统服务的管理 socket 权限 | 默认服务使用 sudo；前台实例显式指定其 socket |
| 网站返回 421 | Host 是否匹配启用站点 | 使用真实域名或 `curl -H 'Host: …'`，不要只请求裸 IP |
| 网站返回 502 | 从处理请求的节点能否直连源站 | 核对源站进程、地址、端口、协议和健康探针 |
| 网站返回 403 / 413 / 503 | 请求 ID、防护原因、源站响应 | 区分太一终止与业务响应；检查具体规则/限制/过载，勿仅凭状态码归因 |
| 保存了配置，行为没变 | 节点应用结果与实际请求路径 | 检查所选站点、策略、节点和发布错误，再重试 |

## 最初五分钟

```sh
sudo tiyi doctor
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -n 200 --no-pager
sudo ss -ltnp
sudo tiyi system health
```

Agent 使用 `tiyi-agent` unit 名。手动前台运行时，查看终端以及命令行指定的路径。

## 无法打开控制台

- 确认配置的 `server.addr` 监听与主机防火墙。
- 80/443 代理监听不是控制台监听（默认 8080）。
- 运行 `tiyi doctor` 检查端口冲突与配置错误。
- systemd 服务无法写状态树时，先核对报告路径，再运行
  `sudo tiyi doctor --fix-state-ownership`。

<a id="reset-password"></a>
## 丢失首次管理员密码

**不要删除 `state.db`。** 首次密码按设计只打印一次。请在太一主机上通过本地管理
socket 重置已有账号：

```sh
sudo tiyi user list
sudo tiyi user reset-password <user-id> --password '<new-strong-password>'
```

若配置了自定义管理 socket，请传入对应路径。socket 文件系统权限就是本地鉴权边界。

## 请求没有匹配站点或进入错误上游

```sh
curl -v -H 'Host: app.example.com' http://127.0.0.1/
sudo tiyi site list
sudo tiyi upstream list
```

依次检查 Host header（含端口规范化）、监听、站点启用状态、最长前缀路径路由、上游
scheme/端口与健康探针。浏览器直接访问 IP 而不带配置 Host，不是有效站点测试。

## 预期攻击没有被拦截

- 确认请求进入预期站点且 WAF 已启用。
- 检查有效策略、engine state、偏执级别、阈值、bypass、IP 列表优先级和路径覆盖。
- 按请求 ID 和规则 ID 查询**安全事件**与**攻击日志**。
- 使用不受信任来源测试；global/site allow 或 bypass 会决定最终结果。
- 修改前预览编译后的策略。

## TLS 或 ACME 失败

检查 DNS、公网可达性、HTTP-01 所需的 80 端口、证书绑定、时钟与 ACME order 详情。
DNS-01 要求受支持 provider 与正确范围凭据。不要把 provider 密钥粘贴到 issue 或支持包。

## Agent 离线或不能应用配置

- 对比 Server URL、注册 token 有效期、时钟、DNS 与网络路径。
- 在同一时间点读取 Server 与 Agent journal。
- 区分离线、身份/协议拒绝、签名失败与 apply 失败。
- 目标版本改变身份或协议契约时，应重新注册 Agent；不要强行恢复不兼容的身份、
  spool 或 bundle 缓存。
- 重连后确认 applied revision/hash，不能只看 online。

## 请求收到太一 503 或绕过 CRS

检查 `X-Tiyi-Enforcement-Reason` 与**日志 → 执行分析**。因果 WAF CPU 拒绝是
`cpu_overload_reject`，只降级 CRS 是 `cpu_overload_bypass`；源站 503 没有这两类
决策。修改阈值前先查看对应节点的 WAF 压力趋势，以及受保护本地管理 socket 上的
`/debug/wafoverload/stats`。观测积压或遥测缺口不会触发 WAF 过载。

## Bot 挑战或 IP 订阅失败

- Bot 防护要求仅 HTTPS 站点。检查证书绑定、浏览器 Cookie/存储策略、系统时间、
  豁免路径和可信列表引用。人工验证还需要 WebAuthn 支持与用户手势。
- IP 订阅应检查同步历史、HTTP 状态、响应大小限制、解析器/JSONPath 输出、删除比例
  hold 与消费者编译结果。更新受保护时，先前已接受快照继续生效。

## 安装器拒绝主机或启动拒绝状态

公开安装器用于干净主机，会拒绝已有二进制、状态数据库、配置或 systemd unit。
运行时会拒绝 schema 或迁移台账与当前二进制不兼容的状态。

不要编辑迁移元数据。请按[升级与迁移指南](upgrade-migration.md)选择兼容的二进制与
状态、完整迁移安装，或执行文档中的 purge 流程。v3.8.0 无法读取 v3.7.2 或更早版本
创建的状态，需要执行 purge 并重新注册远程 Agent。

## 有计数但证据或 SIEM 延迟

打开**系统监控 → 日志管道**，检查队列深度、丢弃、重试与 panic 计数。请求证据会
新增本地/存储/上传通道，直达 SIEM 会新增原始源和每目标通道。精确流量计数、
有界 SecurityFact 样本、保留证据与 SIEM 投递彼此独立。从产生事件的节点测试目标并
修复消费者；除非诊断明确要求，不要重启健康的数据面。

## 控制台恢复与诊断输出阻塞

会话恢复暂时不可用时，先检查网络和组件健康，再在重试页面重试。暂时读取失败不代表会话已经过期；设置保存及应用结果明确前保留草稿。

在 Controller 主机通过受权限保护的本地 socket 查看诊断压力和管理请求延迟：

```sh
sudo curl -fsS --unix-socket /run/tiyi/admin.sock http://tiyi.local/debug/runtime/stats
sudo tiyi system health
```

自定义实例使用实际 socket 路径。核对日志输出消费者和存储压力；诊断队列满时按整条丢弃并计数，持久审计与安全记录走独立路径。不要为了采集诊断而把管理 socket 暴露到网络。

## 收集安全的支持材料

包含版本、模式、脱敏配置、unit、health、`tiyi doctor`、近期相关 journal、站点/上游
ID、时间与时区、请求 ID。删除 JWT、密码、注册 token、私钥、DNS 凭据、cookie 与
敏感请求体。

## API 与配置文件问题

| 现象 | 检查与下一步 |
|---|---|
| 站点导入提示 JSON 错误 | 使用 [site-import.json](templates/site-import.json)，不能上传 apply YAML 或 OpenAPI。 |
| apply 提示未知字段或 unsupported reference | 使用[资源模板](configuration.md)；当前 apply 无法解析 Bot 可信 IP 列表名称，先建列表再在站点 UI 绑定。 |
| API 文档提示 `invalid_oas` | 对照 [OpenAPI 模板](api-protection.md)；根映射用 `basePath: ""` 而非 `/`，检查是否重复拼接基础路径。 |
| 文档已保存，请求行为没变 | 检查发布和服务节点结果；上传或保存草稿并未应用到流量。 |
| 有违规计数但没有样本 | 计数与保留样本独立；确有需要时在日志策略主动启用 Schema 违规采样，默认关闭。 |
| CLI 连不上自定义实例 | 显式传正确 `--admin-socket`，或 `TIYI_API` 与 `TIYI_TOKEN`；`auth login` 不会保存 CLI 会话。 |
