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

新站点创建后立即生效；一步式命令会创建上游池并使用内置 Light 策略。Light 保持
攻击与资源限制拦截，只把常见 MIME/解析器不匹配作为兼容性观察。在
**Application Delivery → Sites** 管理 TLS、路径路由、健康状态与站点级安全覆盖。
公网 DNS 指向太一前，请先配置上传证书或托管 ACME。

同一域名承载多个应用时，使用最长前缀路径路由（例如 `/api/` 与 `/static/`），
保留 fallback，并在保存后逐条探测。

## 2. 建立基线

在**总览**选择站点和时间范围。先看防护链路——Bot 准入 → 限速/挑战 → IP/国家 →
资源护栏 → WAF/CRS → 源站——再检查请求率、终止计数、状态码、Top 攻击源、
规范化 URL Top 与固定 UA 类别。Bot 阶段打开**日志 → Bot 分析**；其他阶段打开
已过滤的**日志 → 执行分析**。通过**日志 → API Inventory**查看发现资产。

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
API key、个人数据与请求体按设计不脱敏，必须限制日志读取权限并使用短保留期。控制台预览先显示 HTTP 请求行（方法、精确目标、客户端 HTTP 版本），再显示 Host 与捕获的请求头。

在**系统管理 → 设置 → SIEM**配置目标。每个目标独立选择源生 Caddy 访问 JSON、
Coraza 审计 JSON 或太一格式事件，并通过 UDP/TCP/TLS 投递。队列满和网络错误只会
丢弃该目标当前事件并增加其管道计数，绝不会拖慢 WAF 响应。

## 3. 调查告警

1. 打开**告警与通知 → 告警中心**，跟随证据链接。
2. 固定站点和时间范围，复制 `X-Request-Id`/唯一请求 ID。
3. 在**日志 → 安全事件**按攻击者、攻击类型或目标分析有界事实样本。
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
6. 应用后监控拦截率、状态码、SecurityFact 和攻击日志。

IP allow list 不是规则排除的替代品。WAF bypass 会跳过后续检查，应比普通单规则
pass 限制得更严格。

### v3.7 自适应控制

- 把**防护 → IP 列表**订阅视为不可信输入：预览解析结果，只绑定已接受的快照；遇到
  **更新受保护**时调查原因，不要绕过空集、超量或非法结果。国家策略使用
  **防护 → Country Access**；`geo:*` 不是 IP 列表条目。
- 站点级 **Bot 防护**只用于仅 HTTPS 站点。先从浏览器检查开始，仅豁免窄范围健康
  检查或登录回调；只有业务允许私密 WebAuthn 设备确认时才启用人工验证。
- 在**系统管理 → 设置 → WAF 过载**中，除非已有明确可用性策略，否则保留
  **继续完整检查**。拒绝模式返回 503 和 `X-Tiyi-Enforcement-Reason:
  cpu_overload_reject`；bypass 模式只跳过 Coraza/CRS，并在**日志 → 执行分析**可见。
- 限速临时封禁与挑战响应是两个独立控制。扩大范围前，在**日志 → 执行分析**核对
  滚动窗口阈值、站点/全局范围、TTL 与最终响应。

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

需要把变更纳入版本控制时，从[四类资源完整清单](templates/apply.yaml)起步，并在
首次 apply 前阅读[替换、引用、事务与回滚规则](configuration.md)。尤其要注意：
apply 的 spec 会替换其管理的字段，并不是 merge patch。

把完整状态目录、配置、外部 KEK、上传证书源文件、license 与声明式清单纳入备份。
必须测试恢复，不能只测试“生成了备份”；参见[升级与迁移](upgrade-migration.md)。

## 7. 接入 Prometheus

太一只在受文件权限保护的本地管理 socket 上暴露 OpenMetrics。先在本机验证：

```sh
sudo curl -fsS --unix-socket /run/tiyi/admin.sock \
  http://localhost/metrics | grep '^tiyi_' | head
```

不要用通用 TCP 代理暴露这个 Unix socket：它还提供免密码的本地管理端点。一个安全、
简单的桥接方法是 node_exporter textfile collector，只转存 metrics 正文。先为
node_exporter 配置
`--collector.textfile.directory=/var/lib/node_exporter/textfile_collector`，
再创建以下 oneshot service 与 timer：

```ini
# /etc/systemd/system/tiyi-metrics-textfile.service
[Unit]
Description=Export Tiyi OpenMetrics to node_exporter textfile collector
After=tiyi.service

[Service]
Type=oneshot
User=root
UMask=0022
NoNewPrivileges=true
PrivateTmp=true
ProtectHome=true
ExecStart=/bin/sh -ec '/usr/bin/curl -fsS --unix-socket /run/tiyi/admin.sock http://localhost/metrics -o /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp; /usr/bin/chmod 0644 /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp; /usr/bin/mv -f /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp /var/lib/node_exporter/textfile_collector/tiyi.prom'
```

```ini
# /etc/systemd/system/tiyi-metrics-textfile.timer
[Unit]
Description=Refresh Tiyi OpenMetrics for node_exporter

[Timer]
OnBootSec=30s
OnUnitActiveSec=30s
AccuracySec=5s
Unit=tiyi-metrics-textfile.service

[Install]
WantedBy=timers.target
```

```sh
sudo install -d -m 0755 /var/lib/node_exporter/textfile_collector
sudo systemctl daemon-reload
sudo systemctl enable --now tiyi-metrics-textfile.timer
sudo systemctl start tiyi-metrics-textfile.service
systemctl status tiyi-metrics-textfile.timer --no-pager
curl -fsS http://127.0.0.1:9100/metrics | grep '^tiyi_' | head
```

Prometheus 抓取现有 node_exporter target：

```yaml
scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['tiyi-host.example.com:9100']
```

主要指标族是 `tiyi_observation_lane_value{lane,field}`、
`tiyi_observation_pipeline_value{field}` 和
`tiyi_api_inventory_value{site_id,field}`。应对 timer/oneshot 失败告警，并观察 queue、
drop 与 panic 字段。若 node_exporter 包使用其他 textfile 目录，请相应调整路径。
