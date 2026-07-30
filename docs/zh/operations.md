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

在**总览**选择站点和时间范围，检查请求率、拦截率、状态码、Top 攻击源、
规范化 URL Top 与固定 UA 类别。通过**安全与流量 → API Inventory**查看发现资产。

观测管道有四个彼此独立的真相平面：

- 数据面精确流量与拦截计数；
- 用于直接调查的不可变紧凑 `SecurityFact`；
- 受独立策略、保留期与存储配额控制的可选明细和请求证据；
- 每个目标一条有界队列的生产节点直达 SIEM。

消费者落后时查看**系统监控 → 日志管道**。SIEM 变慢不能改变精确计数，
也不能阻塞代理请求。

### 请求证据与直达 SIEM

新安装的请求证据默认使用 `security_only`。在**系统管理 → 设置 → 全局日志与证据策略**配置全局策略，再从
站点的**日志与证据**抽屉按需覆盖。`security_only` 为产生 SecurityFact 的请求保留
证据；`retained_logs` 把证据附着到已保留的攻击/访问行。Cookie、Authorization、
API key、个人数据与请求体按设计不脱敏，必须限制日志读取权限并使用短保留期。

在**系统管理 → 设置 → SIEM**配置目标。每个目标独立选择源生 Caddy 访问 JSON、
Coraza 审计 JSON 或太一格式事件，并通过 UDP/TCP/TLS 投递。队列满和网络错误只会
丢弃该目标当前事件并增加其管道计数，绝不会拖慢 WAF 响应。

## 3. 调查告警

1. 打开**告警与通知 → 告警中心**，跟随证据链接。
2. 固定站点和时间范围，复制 `X-Request-Id`/唯一请求 ID。
3. 在**安全与流量 → 安全事件**按攻击者、攻击类型或目标分析不可变事实。
4. 打开匹配的**攻击日志**，再按请求 ID 关联访问日志和运行时错误。
5. 仅在获得授权且确有需要时加载请求证据；Geo/ASN 只能作为网络出口参考。
6. 确认、记录；只有在原因或安全缓解措施验证后才解决。

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

在 **节点 → 安装远端节点** 中签发一次性 Token，再按页面分别显示的下载与
systemd 步骤操作：

```sh
sudo curl -fsSL -o /usr/local/bin/tiyi 'https://tiyi.example.com/download/tiyi'
sudo chmod 0755 /usr/local/bin/tiyi
sudo mkdir -p /etc/tiyi
printf 'TIYI_CONTROLLER_URL=https://tiyi.example.com\nTIYI_AGENT_ENROLLMENT_TOKEN=<一次性Token>\n' | sudo tee /etc/tiyi/tiyi-agent.env >/dev/null
sudo chmod 0600 /etc/tiyi/tiyi-agent.env
sudo tiyi install --mode agent --unit-name tiyi-agent --now
```

在节点页或用 `tiyi agents list` 检查在线状态与已应用 revision。

使用 Agent Group 做稳定目标选择。发布前检查 bundle diff，发布后检查 apply 结果和
代理健康。离线 Agent 与“在线但停留在旧 revision”是两种不同故障。

## 6. 日常与变更检查

每天检查：

- 健康、磁盘、证书到期、Agent 与证据/日志管道积压；
- firing 告警、SecurityFact 趋势与异常 API Inventory；
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
