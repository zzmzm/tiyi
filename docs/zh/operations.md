# 日常运维

本页按常见运维闭环组织：发布、观察、调查、调优、验证。本地 CLI 命令在太一主机
执行；远程操作时增加 `--api URL --token JWT`。

## 1. 发布应用

先启动后端并创建站点，在修改 DNS 前验证路由：

```sh
tiyi site create \
  --name shop \
  --host shop.example.com \
  --upstream-url http://10.0.0.20:9000 \
  --tls none

curl -i -H 'Host: shop.example.com' http://127.0.0.1/
tiyi site list
```

新站点创建后立即生效；一步式命令会创建上游池并使用内置 Standard 策略。在
**Application Delivery → Sites** 管理 TLS、路径路由、健康状态与站点级安全覆盖。
公网 DNS 指向太一前，请先配置上传证书或托管 ACME。

同一域名承载多个应用时，使用最长前缀路径路由（例如 `/api/` 与 `/static/`），
保留 fallback，并在保存后逐条探测。

## 2. 建立基线

在 **Overview** 选择站点和时间范围，检查请求率、拦截率、状态码、延迟与 Top
攻击源。通过 **Monitoring → Telemetry Explorer** 深入查看并使用 API Inventory。

观测管道有三个彼此独立的真相平面：

- 数据面精确流量与拦截计数；
- 用于调查的紧凑保留证据（`SecurityFact` 与 `Finding`）；
- 独立重试的明细/SIEM 投递。

消费者落后时查看 **Monitoring → Log Pipeline**。SIEM 变慢不能改变精确计数，
也不能阻塞代理请求。

## 3. 调查告警

1. 打开 **Detection & Response → Active Alerts**，跟随证据链接。
2. 固定站点和时间范围，复制 `X-Request-Id`/唯一请求 ID。
3. 把 Security Finding 与访问、错误证据关联起来。
4. 查看 Incident 生命周期、来源/目标、Geo/ASN（仅供参考）与 MITRE 投影。
5. 多个 Incident 形成更大来源/目标/TTP 模式时，检查持久化 Attack Campaign。
6. 确认、分派、记录；只有在原因或安全缓解措施验证后才解决。

AI enrich 默认关闭、结构化且仅提供建议。未核对保留证据和编译后策略前，不要应用
AI 建议。

## 4. 安全调优

始终选择最窄变更：

1. 复现并确定规则、路径、站点和客户端类别；
2. 预览有效策略或 UI 差异；
3. 功能支持时先用 log-only/canary；
4. 把排除限制在准确的站点/路径/规则；
5. 同时发送恶意与合法回归请求；
6. 应用后监控拦截率、状态码和新 Finding。

IP allow list 不是规则排除的替代品。WAF bypass 会跳过后续检查，应比普通单规则
pass 限制得更严格。

## 5. 运维 Agent

签发短期注册 token，在目标节点运行生成的安装命令，并检查在线状态与已应用
revision：

```sh
tiyi agents issue-token --tag edge --ttl 1h
tiyi agents list
```

使用 Agent Group 做稳定目标选择。发布前检查 bundle diff，发布后检查 apply 结果和
代理健康。离线 Agent 与“在线但停留在旧 revision”是两种不同故障。

## 6. 日常与变更检查

每天检查：

- 健康、磁盘、证书到期、Agent 与日志管道积压；
- firing 告警、开放 Incident、Campaign 变化与异常 API Inventory；
- SIEM/通知通道投递失败和审计链。

变更前后：

```sh
tiyi doctor
tiyi diff -f desired.yaml
tiyi apply -f desired.yaml
tiyi system health
tiyi audit verify
```

把 `state.db`、KEK、上传证书源文件、license 与声明式清单纳入备份。必须测试恢复，
不能只测试“生成了备份”。

