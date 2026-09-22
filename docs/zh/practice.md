# 实战与进阶

在[快速开始](getting-started.md)中，我们已经让正常请求通过、让攻击被拦截。接下来沿着这个演示继续：切换观察与阻断、调查规则，再尝试 API 防护、真实业务上线、自动化和日常运维。

前两项练习复用你自己的 `quickstart.test` 站点和 9000 后端，保持后端运行。命令都在太一主机执行，默认系统服务使用 `sudo`；改过端口时将 80 换成自己的代理端口，自定义实例还需传入 `--admin-socket`。

<a id="observe-block"></a>
## 1. 同一个请求，观察与阻断有什么区别

仅在自己的演示站点操作。查到 `quickstart` 的 ID，再切换**这个站点**的 WAF 模式：

```sh
sudo tiyi site list
SITE_ID='replace-with-quickstart-site-id'
sudo tiyi site update "$SITE_ID" --waf-mode detection
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
sudo tiyi site update "$SITE_ID" --waf-mode blocking
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
curl -i -H 'Host: quickstart.test' http://127.0.0.1/
```

快速开始的原始演示配置下，依次预期 **200、403、200**。在总览观察处理结果，在攻击日志按请求 ID 查看规则。
`detection` 改变该站点的 WAF 行为；Bot、限速、IP 和 API 规范等独立控制仍可能拦截，不要把它理解成全站所有防护的观察开关。
如果中途停止练习，执行上面的 `--waf-mode blocking` 命令恢复演示站点。

<a id="tune"></a>
## 2. 从一条误报或攻击记录开始调优

先在攻击日志记录站点、时间、请求 ID、规则 ID、命中字段和实际状态码。确认请求经过预期站点，先判断是否为业务正常输入。

想试运行一条请求而不发送给业务源站，可在策略测试页操作，也可查到该站点正在使用的策略 ID 后执行：

```sh
sudo tiyi site get "$SITE_ID"
sudo tiyi policy list
POLICY_ID='replace-with-this-sites-policy-id'
sudo tiyi policy test "$POLICY_ID" --site-id "$SITE_ID" \
  --method GET --url '/?q=1%20UNION%20SELECT%20password%20FROM%20users'
```

检查测试结果中的执行阶段、命中规则与阻断结果。策略测试覆盖原生 IP/国家规则和 Coraza 请求检查；
不执行完整代理链路、Bot、限速、上传/Schema 或响应检查。测试通过后仍需真实请求验证。

要练习精确规则，可在自己的演示站点使用独立策略，在**自定义规则**的可视化编辑器中添加：
请求路径等于 `/lab-denied` 时阻断。预览并保存，等待配置应用后分别请求 `/lab-denied` 和 `/`；前者应被拒绝，后者仍正常。
练习结束删除该规则或恢复原策略，再确认 `/lab-denied` 恢复正常。修改共享策略前先检查所有引用站点。

真实误报优先对具体站点、路径、参数和规则做支持的窄范围例外，复测原来的合法请求和本页 SQL 注入探针。
`log_only` 只取消该规则的阻断分数，其他规则仍可能阻断；给客户端加入全局白名单会扩大放行范围。
保留变更前的策略版本；不符合预期时通过策略历史回滚，并重新核对引用依赖与实际请求。

<a id="api"></a>
## 3. 让 API 接受正确结构，拒绝错误输入

按[API 防护教程](api-protection.md)把简单静态源站换成演示订单 API，导入 `orders-openapi.yaml`，先应用“仅观察”。
只上传文档还不会启用校验。审核能力报告与接口范围，等待服务节点应用结果后测试：

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":2}' http://127.0.0.1/api/orders
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":"two"}' http://127.0.0.1/api/orders
```

演示的观察模式下两条都应为 200，但第二条有类型违规；改成强制校验并应用后，预期分别为 200 和 403。
在检测统计核对同一站点、接口、时间窗口和覆盖情况。若误拦合法客户端，恢复“仅观察”并重新发布。

没有接口文档时，给可学习的 POST/PUT/PATCH 接口发送成功的合法 JSON，在**流量学习**审核字段和类型，保存版本并导出草稿。
先补齐真实业务需要的字段和必填条件，再走预览、应用与验证；学习不会自动变成拦截策略。
继续练上传时，分别测试正常文件、错误字段、错误类型和超限文件；容量在站点策略中设置，文件字段要求在接口规范中设置。

<a id="publish"></a>
## 4. 把演示换成真实业务

准备真实域名、太一入口 IP、各服务节点可达的源站，以及域名证书。按[HTTPS 与路径路由](operations.md#https)操作。
域名可以先用 `curl --resolve` 指向候选节点，验证时保留证书检查：

```sh
# 将域名和 IP 换成你的实际值
curl -i --resolve app.example.com:443:192.0.2.10 https://app.example.com/
```

`192.0.2.10` 是文档示例地址，不能直接连接。HTTP-01 签发要求验证时公网 DNS 和 80 已指向可服务挑战的入口；
希望切换业务 DNS 前先备好证书时，用已有证书或受支持的 DNS-01。

逐项验证登录、搜索、支付回调、上传、WebSocket/长连接（业务使用时）、每条路径路由和未匹配路径。
CDN 后先配置真实客户端 IP 信任链；双节点逐台测试。保留旧入口和配置，确认成功后再切流。
出现问题时按原切流方式退回旧入口；DNS 回退仍受缓存和 TTL 影响。

<a id="automation"></a>
## 5. 把重复变更变成可审核的文件

从[最小建站 YAML](configuration.md#apply)开始。它会新建独立的示例站点，不会替代 `quickstart`。

```sh
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
curl -i -H 'Host: app.example.com' http://127.0.0.1/
sudo tiyi audit verify
```

对同一文件再运行 `diff`，检查是否还有预期外变化。`apply` 会替换其管理的字段；删除文件中的资源条目不会删除在线资源。
更新已有资源时保留先前清单，回退前同样检查差异；演示结束后显式删除这次创建的站点和未再引用的上游。
站点导出用于搬站，不是完整备份；整个实例的恢复要保留[完整状态与配置](upgrade-migration.md)。

需要跨机器脚本时，按[API 认证](api.md#authentication)获取带权限的访问令牌；CLI 登录不会自动替后续命令保存会话。
分页读取完整列表，保留服务端返回的修订号，遇到冲突重新读取并审核；不要写死资源 ID 或跳过发布结果。

<a id="operate"></a>
## 6. 建立自己的日常运维闭环

先做三件能验证结果的事：

1. 在[通知通道](operations.md#notifications)配置值班接收端，点击测试并确认真正收到；再绑定一条有用的告警规则。测试会发送真实消息。
2. 按[备份与恢复](upgrade-migration.md)做一次完整备份，在隔离主机使用匹配版本演练恢复，验证登录、站点、证书和请求。
3. 检查 `sudo tiyi system health`、证书到期、磁盘、节点应用结果和日志管道；需要外部监控时使用[Prometheus 接入](operations.md#prometheus)。

需要多入口再按[远端节点部署](deployment.md#nodes)增加节点。Community 的本机功能完整，远端节点需许可配额。
新增节点在线只是第一步，还需验证配置生效、源站可达和真实请求。
一次只扩大一种控制的范围：IP/国家、限速、Bot、上传或 API 校验；每次记录正常请求、异常请求、结果与撤销方法。
