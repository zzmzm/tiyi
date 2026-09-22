# 日常运维

本页按常见运维闭环组织：发布、观察、调查、调优、验证。本地 CLI 命令在太一主机
执行并使用 `sudo`；远程操作时不加 sudo，增加 `--api URL --token JWT`。

先按任务选择：[通配域名](#wildcard-hosts) · [上线与 HTTPS](#https) · [误报调优](#tuning) · [告警](#notifications) · [监控](#prometheus) · [备份与恢复](upgrade-migration.md#backup)。
想先用演示站点练习，见[实战与进阶](practice.md)。

## 1. 发布应用

先启动后端并创建站点，在修改 DNS 前验证路由：

```sh
sudo tiyi site create \
  --name shop \
  --host shop.example.com \
  --upstream-url http://10.0.0.20:9000 \
  --tls none

curl -i -H 'Host: shop.example.com' http://127.0.0.1/
sudo tiyi site list
```

新站点创建后立即生效；一步式命令直接设置站点内联上游并使用内置 Light 策略。Light 保持攻击阻断；普通参数/正文大小超限默认记录，MIME/解析器不匹配作为兼容性观察。上传、Schema 和其他资源护栏按各自控制执行。在
**应用交付 → 站点** 管理 TLS、路径路由、健康状态与站点级安全覆盖。
公网 DNS 指向太一前，请先配置上传证书或托管 ACME。

同一域名承载多个应用时，使用最长前缀路径路由（例如 `/api/` 与 `/static/`），
保留 fallback，并在保存后逐条探测。

<a id="wildcard-hosts"></a>
### 使用通配域名建站

在**站点 → 新建 / 编辑**中，**主机名**和**别名**都支持 `*.example.com`。
不要填写协议、端口或路径；界面中的多个别名用英文逗号分隔。通配符只替代一级子域名：

| 请求域名 | 是否匹配 `*.example.com` |
|---|---|
| `www.example.com`、`api.example.com` | 匹配 |
| `example.com` | 不匹配；需要单独填入主机名或别名 |
| `a.b.example.com` | 不匹配；需要添加该具体域名，或另设 `*.b.example.com` |

以下独立示例新建一个站点，同时接入通配域名和根域名，并为 API 配置显式加入
`api.example.com`。请替换为自己的域名、站点名称和源站地址：

```sh
sudo tiyi site create --name wildcard-app \
  --host '*.example.com' --alias example.com --alias api.example.com \
  --upstream-url http://10.0.0.20:9000 --tls none
curl -i -H 'Host: api.example.com' http://127.0.0.1/
```

命令行中的 `*.example.com` 要加引号，避免 shell 把 `*` 展开成本地文件名。
公网接入前，还需将具体域名或通配 DNS 记录解析到太一；保存站点不会创建 DNS 记录。

启用 **HTTPS** 前，先准备覆盖通配域名和全部别名的证书。只有 `*.example.com`
的证书不覆盖 `example.com` 或 `a.b.example.com`。可以上传已有证书；通过 ACME
申请通配符证书必须使用 **DNS-01**，HTTP-01 不支持。申请前先配置受支持的
Cloudflare DNS Provider，签发成功后再按[下节](#https)绑定证书并启用 HTTPS。
HTTP 的主机名匹配本身不要求 ACME 或 DNS-01。

使用 **OpenAPI 导入或请求规范校验**时，先把 `api.example.com` 等实际 API 域名
显式加入该站点的主机名或别名，再按该具体域名映射。通配域名能接收请求，但不会
自动创建具体 API 绑定，也不会让 Schema 校验覆盖所有匹配的子域名。后续步骤见
[API 防护教程](api-protection.md)。

<a id="https"></a>
### 把真实站点切到 HTTPS

把 `app.example.com` 替换为自己的域名。HTTP-01 要求该域名的 A/AAAA 指向太一，公网 80 可达；
先确认 DNS 与防火墙，再申请。示例中的 ID 从 list 输出获取：

```sh
sudo tiyi cert issue app.example.com --email admin@example.com
sudo tiyi cert list
sudo tiyi site list
SITE_ID='replace-with-site-id'
CERT_ID='replace-with-issued-certificate-id'
sudo tiyi site update "$SITE_ID" --tls managed-acme --tls-cert-id "$CERT_ID" \
  --tls-http-behavior redirect
curl -i --resolve app.example.com:443:127.0.0.1 https://app.example.com/
```

证书签发成功并覆盖所有站点域名后再绑定。已有企业证书时可用
`sudo tiyi cert upload --name app-cert --cert-pem cert.pem --key-pem key.pem`，绑定时用 `--tls uploaded`。
完整链可用重复的 `--chain-pem` 提供。通过 ACME 申请通配符证书需要 DNS-01；在证书页先配置受支持的 Cloudflare DNS Provider，
核对凭据范围、验证方式和覆盖域名。上传证书需要自行更新，托管证书有自动续期；不要混淆。

### 多源站与路径路由

下面先建两个真实后端组成的池，再把 `/api` 路由给它。替换 IP 和返回的 ID，
`/healthz` 必须在两个后端均返回 200；创建时会进行连通性/探针检查：

```sh
sudo tiyi upstream create --name api-pool \
  --endpoint-url http://10.0.0.20:9000 --endpoint-url http://10.0.0.21:9000 \
  --health-check-path /healthz --health-expected-status 200
sudo tiyi upstream list
sudo tiyi site routing get SITE_ID
sudo tiyi site routing set SITE_ID --route /api=UPSTREAM_ID --unmatched default
```

`routing set` 会替换完整路由表，先保存 `routing get` 结果；保留已有路由时在 set 中全部列出。
匹配采用最长前缀且按路径段边界，`/api` 不匹配 `/apix`。默认保留完整路径，
若源站需要去掉 `/api`，写 `--route /api=UPSTREAM_ID:strip`。
`--unmatched default` 需站点有默认上游；`--unmatched 404` 则拒绝未匹配路径。
测试每一条路由与未匹配路径，核对每个服务节点健康状态；未知或过期报告不等于健康。

### 需要迁移或批量建站

使用[站点导入/导出 JSON](site-import.md)，或[声明式 YAML](configuration.md#apply)。
API 接入按[独立 API 防护教程](api-protection.md)完成，不需要把 OpenAPI 写进启动配置。

## 2. 建立基线

在**总览**选择站点和时间范围。先看防护链路——Bot 准入 → 限速/挑战 → IP/国家 →
资源护栏 → WAF/CRS → 源站——再检查请求率、终止计数、状态码、Top 攻击源、
规范化 URL Top 与固定 UA 类别。Bot 阶段打开**日志 → Bot 分析**；其他阶段打开
已过滤的**日志 → 执行分析**。通过**应用交付 → API 资产**查看发现资产。

查看结果时区分以下数据：

- 数据面精确流量与拦截计数；
- 用于安全事件调查的有界事件样本；
- 受独立策略、保留期与存储配额控制的可选明细和请求证据；
- 从处理流量的节点发送到外部 SIEM 的事件。

消费者落后时查看**系统监控 → 日志管道**。SIEM 变慢不能改变精确计数，
也不能阻塞代理请求。

### 正确区分精确计数与采样调查

总览安全排行、执行分析及阈值告警使用采样前计数；事件分析用保留样本进行关系调查，不能把关联结果视为完整流量总数。跳转执行分析时保留相同站点、时间和 IP。维度容量受限时会显示覆盖缺口，不能把缺失条目当成没有活动。

自动处置保留攻击类型和严重程度过滤。快捷 IP 动作分别展示保存及应用结果，重试沿用同一操作，并支持撤销。判断封禁是否在全部节点生效前，需核对远端部署结果。

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
  **防护 → 国家访问**；`geo:*` 不是 IP 列表条目。
- 站点级 **Bot 防护**只用于仅 HTTPS 站点。先从浏览器检查开始，仅豁免窄范围健康
  检查或登录回调；只有业务允许私密 WebAuthn 设备确认时才启用人工验证。
- 在**系统管理 → 设置 → WAF 过载**中，除非已有明确可用性策略，否则保留
  **继续完整检查**。拒绝模式返回 503 和 `X-Tiyi-Enforcement-Reason:
  cpu_overload_reject`；bypass 模式只跳过 Coraza/CRS，并在**日志 → 执行分析**可见。
- 限速临时封禁与挑战响应是两个独立控制。扩大范围前，在**日志 → 执行分析**核对
  滚动窗口阈值、站点/全局范围、TTL 与最终响应。

## 5. 运维远端节点

在 **节点 → 安装远端节点** 设置 Controller 可达地址、标签、有效期和最多注册节点数，生成安装命令。
按页面的推荐 systemd 命令在目标主机执行，再回到节点页查看本次注册和配置应用结果。
二进制平台、许可、完整命令和排障边界见[远端节点部署](deployment.md#nodes)。

`sudo tiyi agents list` 可查询节点状态。站点配置会发布到本机及全部已注册节点，离线节点重连后接收；
分组便于组织机器，不代表某站点只在该组生效。核对各节点当前配置、代理和源站健康，再发送真实请求。
离线和在线但配置未应用需要分别处理。

## 6. 日常与变更检查

每天检查：

- 健康、磁盘、证书到期、Agent 与证据/日志管道积压；
- firing 告警、SecurityFact 趋势与异常 API Inventory；
- SIEM/通知通道投递失败和审计链。

变更前后：

```sh
sudo tiyi doctor
sudo tiyi diff -f desired.yaml
sudo tiyi apply -f desired.yaml
sudo tiyi system health
sudo tiyi audit verify
```

需要把变更纳入版本控制时，从[四类资源完整清单](templates/apply.yaml)起步，并在
首次 apply 前阅读[替换、引用、事务与回滚规则](configuration.md)。尤其要注意：
apply 的 spec 会替换其管理的字段，并不是 merge patch。

把完整状态目录、配置、外部 KEK、上传证书源文件、license 与声明式清单纳入备份。
必须测试恢复，不能只测试“生成了备份”；参见[升级与迁移](upgrade-migration.md)。

<a id="prometheus"></a>
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

## 8. 运维 API 资产

打开 **API 资产**并选择站点，检查接口树。发现接口不等于纳入清单；通过**纳入
API 清单**，或导入文档、审核域名和基础路径映射后应用。新纳入接口不会自动开启
校验。隐藏只影响默认列表，不改变请求处理或学习。

打开接口查看请求规范、流量样本与学习结果。**请求规范校验**在支持时提供不校验、
仅观察和强制校验；选择方式、核对变化后应用一次，等待全部服务节点回执匹配再判断
已生效。不支持的约束不能开启强制模式。未纳入接口请求的处理由独立的站点/文档
范围设置决定；拦截前先纳入正常健康检查、回调和 OPTIONS 接口。

符合条件的 POST/PUT/PATCH 接口在采样配置生效后自动学习有界的成功 JSON 结构，
不保存字段值、不覆盖人工定义、不自动开启拦截。在**学习结果**审核并保存版本，
下载 OpenAPI 草稿，或按正常审核和应用流程建立规范。采样限额使学习样本数与请求
数不同，证据不完整时会明确显示。

普通正文与上传容量统一在站点策略中配置；接口规范可增加文件字段要求，不重复设置
站点容量。**检测统计**显示服务器计算的实际窗口和覆盖情况。确需违规示例时再在
全局/站点日志策略中显式开启 Schema 违规样本；关闭采样仍保留计数。

通过**管理 API 文档 → 历史与回滚**查看发布结果、恢复审核过的历史版本。当前意图
与实际服务状态分开展示。升级已有部署前先阅读[v3.8.0 发行说明](release-3.8.0.md)。

<a id="notifications"></a>
## 9. 配好能送达的告警

进入 **告警与通知 → 通知通道**，选择 Webhook、Slack、PagerDuty、飞书、企业微信或邮件，
填写该通道要求的地址/凭据并保存。点击测试会发送真实通知，核对接收端而不只看“已保存”。
在 **告警规则** 选择需要的事件、站点/节点范围、时间窗口和阈值，绑定通道，预览内容后启用。
首次可从证书即将过期、节点离线、HTTP 错误率或慢请求规则开始。
确认触发、重复通知与恢复通知的内容符合值班需要；维护窗口使用静默，并设置明确结束时间。
告警中心的确认/解决记录操作人和备注；手动解决不代表根因已经消失。

<a id="tuning"></a>
## 10. 调优 WAF 和紧急虚拟补丁

新站点默认 Light。需要更严格的 Content-Type/解析要求时评估 Standard/Strict，先验证登录、搜索、支付回调和上传。
按站点关联策略；修改共享策略会影响全部引用站点，先检查影响范围，必要时创建独立策略。
误报从攻击日志打开规则证据，优先对准确的规则、站点、路径做例外；单纯自定义规则 `pass` 不保证后续 CRS 不再拦截。
自定义规则编辑器提供路径、方法、请求头等虚拟补丁模板；填写实际业务值后查看预览，再同时验证正常和恶意请求。
`log_only` 不再贡献该规则阻断分数，但其他规则仍可阻断；完全 bypass 会失去后续检查。
策略历史支持回滚，回滚依赖的共享列表/国家库/外部 CRS 仍需存在；它不回滚业务数据、站点设置或日志。

Bot 浏览器/人工挑战不适合没有交互能力的 API 客户端。先识别调用方，再选择路径/IP 豁免或其他限速规则。
IP 列表只包含地址，需绑定允许/拒绝/观察行为；国家访问规则使用已激活的 Country 数据库。
跨节点计数或日志缺口应显示为覆盖不足，不能用缺失数据断言没有攻击。AI 建议始终需要结合实际请求核对。

## 自定义拦截页面与 API 错误

六类防护共用模板、各自配置状态码。使用[完整响应模板与回退步骤](responses.md)，并核对 HTML/JSON 两种真实响应。
