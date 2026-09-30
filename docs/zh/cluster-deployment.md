# 集群部署：一个 Controller、多台 Agents 与负载均衡

适用版本：**v3.8.0**，复核日期：**2026-09-30**。**需要流量节点冗余或横向扩容时，推荐一个 Controller、至少两台远端 Agents，前面配置外部高可用负载均衡。** 第一次使用或可以接受维护窗口的小规模业务，采用[一台 Controller + 内置 Agent](single-deployment.md)更简单。

```text
业务流量
访客 ──> 高可用 LB / VIP ──┬─> Agent A ──┬─> 应用源站
                           └─> Agent B ──┘

管理与配置
管理员 ──> HTTPS 管理网关 ──> 唯一 Controller
Agent A / Agent B ── 主动建立 HTTPS 长连接 ──> 唯一 Controller
```

LB 的业务后端池加入 **Agent 的业务监听**，通常是 80/443。Controller 使用独立、稳定的管理 URL。此拓扑建议将 Controller 的内置数据面留在业务 LB 池外，避免管理主机维护与资源使用占用业务节点；内置数据面仍然存在并接收配置，无须切换成某种 Controller-only 运行模式。

这是集中管理的 WAF 节点集群。太一只有一个可写 Controller，没有内置选举、状态复制或 Controller 自动故障切换。外部 LB 分发到 Agents；太一的上游池则负责把允许的请求分发到应用源站，两层职责不同。

<a id="prepare"></a>
## 1. 准备主机与网络

起步配置为一个 Controller、位于不同主机/故障域的两台 Agents，以及托管高可用 LB 或经过 VIP/切换验证的两台 LB。单台 LB 主机仍是单点。各层通过私网连接；移除一台 Agent 后，剩余容量应能承受业务峰值。

| 连接 | 放行范围 | 用途 |
|---|---|---|
| 访客 → LB | 业务 80/443 | 公网站点入口；业务 DNS 指向这里 |
| LB → Agents | 配置的 HTTP/HTTPS 监听 | 业务转发与健康探针 |
| 管理员 → 管理网关 | HTTPS 443，仅管理来源 | 控制台与 API |
| Agents → 管理网关 → Controller | 出站 HTTPS 443 → 管理 8080 | 注册、长连接、配置与观测投递 |
| Controller 和全部接收配置的节点 → 源站 | 实际应用端口 | 保存时校验与运行时代理 |
| 节点 → DNS、时间服务、配置的 SIEM；Controller → CA/DNS 提供商 | 所需目的端 | 解析、对时、外部投递与证书续期 |

Agent 的业务入口只允许 LB 和授权探针/运维来源；源站入口限制为太一，并保留应用所需依赖。不要向网络暴露特权管理 socket 或 Caddy 管理接口。

每个节点使用独立持久磁盘和 Agent 身份/状态，不跨主机共享一份 Agent 状态目录或 SQLite 数据库。保持时钟同步，全体使用同一个已复核的太一构建。Community 包含内置节点，**远端 Agents 配额为 0**；注册前须导入足够配额的签名许可。

<a id="controller"></a>
## 2. 安装 Controller 并注册 Agents

按[单机安装步骤](single-deployment.md#install)安装 Controller。使用可信 HTTPS 网关为管理监听提供稳定地址，例如 `https://control.example.com`。网关转发到 Controller 管理端口，支持 Agent 的双向长连接，避免过短空闲超时或破坏流式传输的缓冲；实际验证通过该网关注册并持续保持连接。

管理网关与 Agent 业务池独立。把太一站点的源站写成 `127.0.0.1:8080` 会把配置分发到所有节点，并分别指向各自的回环地址，无法将整个集群的管理流量送到 Controller。同主机部署网关时，使用独立 IP/端口避免与太一监听冲突。为管理域名配置覆盖证书，浏览器访问启用 `auth.refresh_cookie_secure: true`。

在 **系统管理 → 关于** 导入许可，然后打开 **节点 → 安装远端节点**，选择稳定 HTTPS 地址、有效期和最多节点数，生成 systemd 安装命令。也可在 Controller 主机执行：

```sh
sudo tiyi agents install-command --controller-url https://control.example.com \
  --tag edge --ttl-seconds 3600 --max-nodes 2
```

将生成的命令在到期前分别运行于两台目标 Agent 主机。命令含注册凭据，保持私密，管理网关日志应省略安装 URL 的查询参数。生成脚本安装 `tiyi-agent`；这些主机无须再安装 Controller 服务。下载使用 Controller 自身平台的二进制，生成流程要求 OS/架构匹配。异构主机应准备同版本、对应平台的签名二进制，走文档中的高级安装方式。

在 Controller 执行 `sudo tiyi agents list` 并查看节点页面，核对每台 Agent 配置应用成功；仅在线不足以证明可服务。Agents 继承 Controller 实际数据面监听地址，所有 Agent 都须预留相同的监听端口。

<a id="site"></a>
## 3. 发布应用并选择 TLS

在 Controller 创建上游池和站点，源站地址必须让 **Controller、其内置节点和每台远端 Agent** 都能访问。`127.0.0.1` 在每台机器指向自身；共享应用使用真实私网源站地址。保存站点、启用所需 WAF 策略并配置证书，检查各服务节点结果后再加入 LB。

保存站点会向内置节点及全部已注册 Agents 下发。分组/标签用于组织节点，不限制站点部署范围；多地域方案需要考虑共同的站点配置和源站可达性。

| TLS 拓扑 | 适用情况 | 必要条件 |
|---|---|---|
| 客户端 HTTPS → 七层 LB → 校验证书的 HTTPS Agent | LB 可以终止 TLS 时的通用起点 | LB 与 Agent 证书、后端 CA/域名校验、保留 Host/SNI、验证转发头 |
| 客户端 HTTPS → 保留源 IP 的四层 LB → Agent TLS | TLS 必须在太一终止 | Agent 证书、实测源 IP 保留、带站点信息的 TLS/HTTP 健康探针 |
| 客户端 HTTPS → 七层 LB → HTTP Agent | 已明确接受的私网信任边界 | 保护未加密后端链路，正确传递客户端 IP 和请求协议 |

四层 LB 若替换客户端源地址，不能往加密请求里写入 `X-Forwarded-For`。v3.8.0 太一配置入口没有提供 PROXY protocol 监听选项，不要开启 `send-proxy`/`send-proxy-v2` 并假定可用；优先选择可验证的七层转发或实测保留源地址的四层服务。

Agent 使用 TLS 时，由太一 Controller 申请/续期受管证书并下发，Agents 不独立申请。DNS-01 避免依赖 LB 转发 HTTP 挑战，也支持通配符；v3.8.0 支持 Cloudflare DNS-01，Route53/Aliyun 驱动不可用，也可以上传证书。使用 HTTP-01 时，公网 80 和 `/.well-known/acme-challenge/` 必须到达在线 Agent 的挑战处理器，申请/续期前移除断连节点，并经真实 LB 验证续期。外部终止 TLS 的 LB，其证书安装和续期由运维独立负责。参见[证书操作](operations.md#https)与 [Let's Encrypt 挑战类型](https://letsencrypt.org/docs/challenge-types/)。

<a id="load-balancer"></a>
## 4. 配置转发、真实客户端 IP 与健康检查

保留业务 Host 和后端 SNI、请求方法/正文及必要协议能力。相似的短 HTTP 请求可从轮询开始；长连接场景按实测考虑最少连接。避免对已经可能到达源站的 POST、支付或上传做宽泛重试。

第一层可信七层入口应使用验证后的值覆盖客户端自行提交的转发头。在 **防护策略 → 客户端 IP** 描述实际代理路径，只信任 LB 真实出口 IP，使用永久 IP 列表条目。CDN → LB → 太一时，也要验证 CDN 到 LB 的一跳；把头直接改成 CDN 对端地址会丢失访客 IP。逐节点验证解析，并发送伪造转发头测试。参见[客户端 IP 配置](deployment.md#client-ip)。

由应用实现低成本的 `GET /_edge/ready`，仅在所需依赖就绪时返回 200。这是需要在源站实现的示例端点，**不是太一内置路由**。每台 Agent 的探针带上业务 Host 和 HTTPS SNI，实际经过 TLS、路由、WAF 准入与源站连接。一条探针成功不能证明所有站点健康或 WAF 会阻断，还要分别验证关键站点和受控攻击。需要 Bot/认证例外时，限定为探针端点与实际探针来源，避免绕过全部 WAF 检查。

不要把 Controller 的 `/healthz` 当作 Agent 就绪检查，它只表示管理进程存活。`/readyz` 位于本地特权管理 socket，不是公开的 Agent LB 目标。LB 成员资格也不能只依赖 Controller 连通性：已经配置并获准服务的 Agent 可以在其离线时继续处理流量。

### 单个业务域名的 HAProxy 起点

示例采用七层 LB 终止 TLS，再经证书校验的 TLS 转发到两台 Agents。按实际版本复核 [HAProxy 配置手册](https://docs.haproxy.org/2.8/configuration.html)，通过操作系统支持的包/服务流程安装 HAProxy。在 LB 主机下载[完整配置起点](templates/haproxy-cluster.cfg)：

```sh
curl -fsS https://www.tiyisec.com/zh/docs/templates/haproxy-cluster.cfg \
  -o haproxy-cluster.cfg
```

修改域名、Agent IP/端口、CA 文件和前端 PEM 路径。先在 `/etc/haproxy/certs/app.example.com.pem` 准备 LB 证书链与私钥，在太一配置覆盖业务域名的 Agent 证书，并实现探针端点。LB 证书文件包含私钥，应限制权限；下载配置不会安装证书或创建高可用。

```text
global
    log /dev/log local0

defaults
    log global
    mode http
    option httplog
    timeout connect 5s
    timeout client 60s
    timeout server 60s
    timeout tunnel 1h

frontend public_http
    bind :80
    http-request redirect scheme https code 301

frontend public_https
    bind :443 ssl crt /etc/haproxy/certs/app.example.com.pem
    acl app_host hdr(host) -i app.example.com app.example.com:443
    http-request deny deny_status 421 unless app_host
    http-request del-header Forwarded
    http-request del-header X-Real-IP
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Proto https
    http-request set-header X-Forwarded-Host %[req.hdr(Host)]
    default_backend tiyi_agents

backend tiyi_agents
    balance roundrobin
    option httpchk
    http-check connect ssl sni app.example.com
    http-check send meth GET uri /_edge/ready ver HTTP/1.1 hdr Host app.example.com
    http-check expect status 200
    default-server inter 3s fall 3 rise 2
    server agent_a 10.20.0.21:443 ssl verify required ca-file /etc/ssl/certs/ca-certificates.crt verifyhost app.example.com sni str(app.example.com) check
    server agent_b 10.20.0.22:443 ssl verify required ca-file /etc/ssl/certs/ca-certificates.crt verifyhost app.example.com sni str(app.example.com) check
```

起点假设访客直连 LB、只有一个业务域名，并使用 DNS-01 或上传证书。80 端口重定向**没有显式转发**太一 HTTP-01 挑战；选择 HTTP-01 前须另行设计挑战路由。多个站点需扩展按域名的路由/探针，按实际上传和长连接调整超时。失败/恢复次数只是初始参数，不保证固定摘除时长。太一对应用上游的健康检查与 LB 对 Agents 的检查分别配置。

在 LB 主机先校验。如果已有配置，先保存可回退副本，再在已评估的流量窗口安装并重载：

```sh
sudo haproxy -c -f ./haproxy-cluster.cfg
sudo install -m 0644 haproxy-cluster.cfg /etc/haproxy/haproxy.cfg
sudo systemctl reload haproxy
```

语法校验必须成功，再检查服务状态、两台后端的探针和公网请求。启用失败时恢复保存的配置，重新校验并重载。全新 HAProxy 服务可能需要首次启动而非重载。两台 LB 应采用等效配置并实测切换，或直接使用托管高可用服务。

<a id="acceptance"></a>
## 5. 逐节点验证，再切换业务 DNS

在授权探针主机执行，替换示例地址/域名，使用有效证书：

```sh
# 直连 Agent A，同时保留 Host 与 TLS SNI：预期 200
curl --fail --resolve app.example.com:443:10.20.0.21 \
  https://app.example.com/_edge/ready

# 直连 Agent B：预期 200
curl --fail --resolve app.example.com:443:10.20.0.22 \
  https://app.example.com/_edge/ready

# Agent A 的受控 WAF 探针：默认阻断策略预期 403
curl -i --resolve app.example.com:443:10.20.0.21 --get \
  --data-urlencode 'q=1 UNION SELECT password FROM users' https://app.example.com/
```

切换 DNS 前，在 Agent B 和 LB VIP 上重复 WAF 探针，选择自己控制的测试站点/路径；预期结果与实际策略及防护响应状态一致。验收不要用 `-k` 关闭证书校验。通过 LB 核对真实客户端 IP 与伪造防护，再把业务 DNS 指向 VIP，重复公网检查。通过按节点区分的观测或 LB 后端计数确认两台都收到流量；浏览器刷新不能单独证明流量分布。

称为高可用之前，演练故障与恢复：

| 演练 | 预期结果 |
|---|---|
| 将一台 Agent 排空，再停止服务 | 新请求进入剩余健康节点；已断开的连接可能需要客户端重连；剩余容量满足目标 |
| 恢复这台 Agent | 版本/配置正确，真实请求和探针通过后再入池 |
| 在受控窗口中断 Controller 连通性 | 已获准服务的 Agents 使用最后接受的配置；管理、新发布/注册和集中视图实时性不可用 |
| 停止活动 LB | 托管服务/VIP 切换在实测目标内恢复新连接，已有连接可能断开 |
| 让一个应用源站故障 | 上游池行为和 Agent 探针符合应用策略，没有绕过 WAF 的路径 |

所有 Agents 不健康时返回失败，不要悄悄直连未受保护的源站。

<a id="operate"></a>
## 6. 容量、状态与恢复维护

- **扩容与升级：** 新节点先留在 LB 池外，确认配置应用和真实访问后再入池。移除/升级节点时先排空，等待连接结束后停机。只有明确兼容状态/协议的版本才能滚动升级；旧版本 → v3.8.0 需要[新状态与重新注册](upgrade-migration.md)，不是普通滚动更新。
- **有状态行为：** 限速窗口与运行时临时缓解状态属于各节点，不构成精确的全局集群预算。会话粘滞可帮助应用会话或身份流量集中，但不会创建共享状态。跨节点测试 Bot 通行凭据、重连与应用会话；要求精确全局限制时应另选合适的共享准入层。
- **观测：** 监控各节点 CPU/内存/磁盘、WAF 结果、源站健康、有界队列积压/覆盖缺口，以及 LB 后端失败。Controller 长期离线时，业务继续运行也可能耗尽观测保留容量。确保每个产生日志的节点都能投递 SIEM，在证书耗尽有效期前监控到期/续期。
- **Controller 恢复：** 明确可接受的管理 RTO/RPO，一致备份完整状态/配置/KEK/license/证书及匹配二进制，演练[恢复](upgrade-migration.md#restore)，保留稳定管理 URL。启动恢复副本前先隔离/停止原 Controller，不能同时运行两份克隆的可写状态。旧备份可能落后于节点身份或已接受配置，须核对重连/协调并有计划地恢复。

只有 LB、源站、网络与剩余容量同样满足可用性目标，这个拓扑才提供业务节点冗余。Controller 恢复仍是运维流程；其不可用时，Agents 无法自行续期证书或取得新策略。
