# 发现接口、导入规范与保护 API

适用版本：**v3.8.0**。在 **应用交付 → API 资产** 选择站点，可以查看实际流量中的接口，
导入 OpenAPI/Swagger 文档，检查请求规范，并逐接口选择“不校验 / 仅观察 / 强制校验”。

| 你手上的材料 | 推荐入口 | 做完后得到什么 |
|---|---|---|
| 已有 OpenAPI/Swagger 文件 | 导入 API 文档 | 可审核的接口清单、请求规范和校验能力报告 |
| 有 JSON 流量，没有文档 | 流量学习 | 不含字段值的结构版本，可下载 OpenAPI 草稿后审核 |
| 想控制文件上传 | 站点策略的请求检查 + 接口请求规范 | 全站容量上限和接口文件字段要求 |
| 想知道是否已阻断 | 接口校验状态、服务节点结果、检测统计 | 已发布配置的节点结果和真实请求检测结果 |

API 清单纳入、行隐藏、流量学习、校验开关是独立设置。把接口放入清单或导入文档不会自动启用拦截。

## 1. 准备一个可重复验证的 API

先完成[快速开始](getting-started.md)中的 `quickstart.test` 站点。停止那里的 Python 静态源站，在同一主机运行以下测试 API。
它会接受任意小请求体，便于确认是太一完成了校验。仅用于本机演示，不作为生产服务。

```sh
cat > demo-origin.py <<'PY'
#!/usr/bin/env python3
"""Local documentation origin. Bind to loopback; do not expose as an app."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json

class Demo(BaseHTTPRequestHandler):
    def reply(self, status, data):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self.reply(200, {'message': 'Hello from the origin'})

    def do_POST(self):
        size = int(self.headers.get('Content-Length', '0'))
        if size > 65536:
            self.reply(413, {'error': 'demo limit is 64 KiB'})
            return
        self.rfile.read(size)
        # Deliberately accepts any small body: Tiyi performs validation.
        self.reply(200, {'message': 'Order received'})

ThreadingHTTPServer(('127.0.0.1', 9000), Demo).serve_forever()
PY
python3 demo-origin.py
```

保持该终端运行，在另一个终端执行正常请求：

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":2}' http://127.0.0.1/api/orders
```

应得到 **200** 和 `Order received`。这一条真实请求也让 API 资产页开始发现 `POST /api/orders`。
下载版：[demo-origin.py](templates/demo-origin.py)。

## 2. 复制 OpenAPI 文档

将以下整个命令粘贴到太一主机，得到可上传的 `orders-openapi.yaml`：

```sh
cat > orders-openapi.yaml <<'YAML'
openapi: 3.0.3
info:
  title: Orders API
  version: 1.0.0
servers:
  - url: http://quickstart.test
paths:
  /api/orders:
    post:
      operationId: createOrder
      summary: Create an order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [sku, quantity]
              properties:
                sku:
                  type: string
                quantity:
                  type: integer
            example:
              sku: BOOK-1
              quantity: 2
      responses:
        '200':
          description: Order received
YAML
```

下载版：[orders-openapi.yaml](templates/orders-openapi.yaml)。用于自己的 API 时，改 `servers`、路径、方法、字段和必填列表。
本例的 `servers` 没有 `/api` 前缀，因为路径已经含 `/api/orders`；不要重复添加前缀。

支持导入 OpenAPI **3.0 / 3.1 / 3.2** 和 Swagger **2.0** 的 JSON/YAML，源文件上限 **8 MiB**。
上传文件，不是在线 URL；不会自动抓取远程引用。API 映射的根路径必须写 `basePath: ""`，不能写 `/`。导入版本支持不等于每个约束都能执行，能力报告会列出不能校验的部分。
响应定义用于文档；不要把它当成已启用的响应体校验或业务鉴权。

## 3. 在控制台审核并发布

**通配站点：**`*.example.com` 可以接收匹配的请求，但不能直接作为具体 API 映射。请先把 `api.example.com` 等实际 API 域名加入站点主机名或别名，再映射该具体域名。通配路由和通配符证书都不会自动让 Schema 校验覆盖所有子域名，详见[通配域名建站](operations.md#wildcard-hosts)。

1. 进入 **应用交付 → API 资产**，选择 `quickstart`，导入上一步文件。
2. 确认目标主机 `quickstart.test`、基础路径留空（根路径），预览应显示 `POST /api/orders`。出现重复 `/api` 或错误域名时先修正映射。
3. 核对已有接口的匹配、新增接口与覆盖范围；这里只声明一个演示接口，不把未知业务路径视为完整清单。
4. 应用审核后的文档。打开该接口的 **请求规范**，应能看到 `sku` 字符串和 `quantity` 整数，且两者必填。
5. 先选 **仅观察**，预览并应用变更。检查服务节点结果；保存成功、排队中、应用失败和已生效不可混为一谈。

上传、保存草稿、预览都不等于发布。遇到不支持的约束，先缩小为可支持的规范并重新预览；不能跳过能力检查宣称强制校验已开启。

## 4. 先观察，再验证阻断

在仅观察模式发送类型错误：

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":"two"}' http://127.0.0.1/api/orders
```

在本例的 Light 策略与无额外规则条件下应仍返回 **200**，检测统计出现违规；其他 WAF 规则仍可独立拦截。
同时发送正常示例，核对两者被识别为同一接口。统计按已完成时间桶汇总，等待刷新后查看；保留相同站点、接口与时间范围。

确认能力报告支持目标检查后，将此接口切换为 **强制校验**，预览、应用并等待服务节点结果。
再次发错误示例，应返回 **403** 且不进入测试源站；正常示例仍应为 200。具体拒绝原因以响应与该请求的检测/执行结果为准。
若业务受影响，将该接口恢复为仅观察并重新发布，或从发布历史恢复审核过的版本，再验证两类请求。

“未纳入接口”的放行/观察/拦截单独控制，并受已发布文档覆盖范围约束。首次导入局部文档时保持放行，
核对健康检查、回调、静态路径和合法旧客户端后再收紧。

## 5. 没有文档：从 JSON 流量学习

为符合条件的 POST/PUT/PATCH 接口查看 **流量学习**，让合法成功 JSON 请求通过太一。
学习收集有界的字段结构、类型和计数，不保留字段值；可审核已保存版本、手动保存当前版本、
下载 OpenAPI 草稿或建立可编辑请求规范。保存后走同样的审核、预览和发布步骤。
学习不会自动修改人工规范，也不会自动启用强制校验。低样本、错误响应、未匹配流量和学习暂停都应先在状态说明中确认。
字段名称本身可能敏感；可按需暂停或清除学习记录。

## 6. 上传与请求大小

在站点所用策略的 **请求检查** 中配置普通请求体、单文件、文件合计、参数数量与结构容量。
在接口 **请求规范** 配置允许的文件字段及受支持的类型/数量等要求。
上传验证应覆盖合法文件、超限文件、错误字段与请求取消，观察真实响应和源站是否收到内容。
文件结构检查不是杀毒、恶意软件检测或内容安全审核；这类业务能力仍需专门的源站服务。

## 7. CLI 与 API 自动化

以下需要 `jq`。上传只创建草稿，预览不改变在线请求处理：

```sh
sudo tiyi site list
SITE_ID='replace-with-quickstart-site-id'
sudo tiyi api-document upload --site "$SITE_ID" --file orders-openapi.yaml \
  --idempotency-key orders-v1 > source-result.json
jq '{siteId: .source.siteId, sourceId: .source.id,
     mappings: [{host:"quickstart.test",basePath:"",
                 serverUrl:"http://quickstart.test",approved:true}]}' \
  source-result.json > declaration-preview.json
sudo tiyi api-document declaration-preview -f declaration-preview.json > preview-result.json
jq -r '.reportJson' preview-result.json | base64 -d
```

`api-document` 的其他命令用 `--request-file FILE`（`-f -` 可从 stdin 读取严格 protobuf JSON）。
二进制字段如 `reportJson` 在 JSON 中是 base64，需要解码；不要把它当普通 JSON 字符串再次解析。
要完成发布，依次审核声明、生成校验 profile/binding、预览 control，再提交服务端返回的 approval。
所需字段、操作顺序和权限见[API 参考](api.md#api-documents)及[ApiSchemaService 完整定义](../reference/services/api_schema.md)。
不要伪造哈希、revision 或复用已过期预览。返回成功后还要检查服务节点状态和真实请求。
