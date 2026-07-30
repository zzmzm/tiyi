# 排障

按从外到内的顺序诊断：进程、监听、站点匹配、路由、WAF、上游。每次只改变一层，
并保留失败请求的 ID。

## 最初五分钟

```sh
tiyi doctor
systemctl status tiyi --no-pager
journalctl -u tiyi -n 200 --no-pager
ss -ltnp
tiyi system health
```

Agent 使用 `tiyi-agent` unit 名。开发环境前台运行时，查看终端以及命令行指定的路径。

## 无法打开控制台

- 确认配置的 `server.addr` 监听与主机防火墙。
- 80/443 代理监听不是控制台监听（默认 8080）。
- 运行 `tiyi doctor` 检查端口冲突与配置错误。
- systemd 服务无法写状态树时，先核对报告路径，再运行
  `sudo tiyi doctor --fix-state-ownership`。

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
tiyi site list
tiyi upstream list
```

依次检查 Host header（含端口规范化）、监听、站点启用状态、最长前缀路径路由、上游
scheme/端口与健康探针。浏览器直接访问 IP 而不带配置 Host，不是有效站点测试。

## 预期攻击没有被拦截

- 确认请求进入预期站点且 WAF 已启用。
- 检查有效策略、engine state、偏执级别、阈值、bypass、IP 列表优先级和路径覆盖。
- 按请求 ID 和规则 ID 查询 Finding/Security 证据。
- 使用不受信任来源测试；global/site allow 或 bypass 会决定最终结果。
- 修改前预览编译后的策略。

## TLS 或 ACME 失败

检查 DNS、公网可达性、HTTP-01 所需的 80 端口、证书绑定、时钟与 ACME order 详情。
DNS-01 要求受支持 provider 与正确范围凭据。不要把 provider 密钥粘贴到 issue 或支持包。

## Agent 离线或不能应用配置

- 对比 Server URL、注册 token 有效期、时钟、DNS 与网络路径。
- 在同一时间点读取 Server 与 Agent journal。
- 区分离线、身份/协议拒绝、签名失败与 apply 失败。
- v3.4.0 拒绝 schema 低于 47 的数据库和旧 Agent 身份/bundle 状态；按
  [重置指南](upgrade-v3.4.md)重新注册。
- 重连后确认 applied revision/hash，不能只看 online。

## 有计数但证据或 SIEM 延迟

打开**系统监控 → 日志管道**，检查队列深度、丢弃、重试与 panic 计数。请求证据会
新增本地/存储/上传通道，直达 SIEM 会新增原始源和每目标通道。精确流量计数、
不可变 SecurityFact、保留证据与 SIEM 投递彼此独立。从产生事件的节点测试目标并
修复消费者；除非诊断明确要求，不要重启健康的数据面。

## 收集安全的支持材料

包含版本、模式、脱敏配置、unit、health、`tiyi doctor`、近期相关 journal、站点/上游
ID、时间与时区、请求 ID。删除 JWT、密码、注册 token、私钥、DNS 凭据、cookie 与
敏感请求体。
