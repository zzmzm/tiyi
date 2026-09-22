# 自定义拦截响应

适用版本：**v3.8.0**。让网站访客知道发生了什么，并能向你提供请求 ID；为 API 客户端返回可解析的 JSON。
在 **系统管理 → 设置 → 拦截响应** 选择输出格式、场景状态码、标题与提示，预览后点击 **保存防护响应**。

## 1. 选择格式与场景

同一套 HTML/JSON/纯文本/自定义模板供以下六个场景共用，具体场景由实际拦截环节选择：

| 场景 | 默认状态码 |
|---|---|
| WAF 拦截 `waf_block` | 403 |
| IP 拒绝 `ip_deny` | 403 |
| 国家访问拒绝 `country_deny` | 403 |
| 限速 / CC `rate_limit` | 429 |
| Bot 最终拒绝 `bot_block` | 403 |
| 服务保护 `service_unavailable` | 503 |

`auto` 根据请求 Accept 选择：含 `text/html` 返回 HTML，否则 JSON。
也可固定 `html`、`json`、`plain`、`custom`。各场景状态码范围为 400–599；改动会影响客户端实际看到的状态和统计。
源站自身返回的普通 403 不会被替换。浏览器挑战的交互页面、机器验证和协议/正文资源错误保留各自的处理方式。

## 2. 可以直接修改的完整模板

本例保留默认状态码，只改公开文案与共享格式。需要 jq；先保存当前设置，再应用完整的单个配置项。
已有设置请先检查备份，选好窗口后执行。下载版：[security-responses.json](templates/security-responses.json)。

```sh
umask 077
cat > security-responses.json <<'JSON'
{
  "security.responses.config": {
    "templates": {
      "active": "auto",
      "html": {
        "body": "<h1>{response.title}</h1><p>{response.message}</p><p>{request.id}</p>",
        "contentType": "text/html; charset=utf-8"
      },
      "json": {
        "body": "{\"status\":{response.status_code},\"title\":\"{response.title}\",\"message\":\"{response.message}\",\"request_id\":\"{request.id}\"}",
        "contentType": "application/problem+json"
      },
      "plain": {
        "body": "{response.title}. {response.message} Request ID: {request.id}",
        "contentType": "text/plain; charset=utf-8"
      },
      "custom": {
        "body": "{response.title}. {response.message}",
        "contentType": "text/plain; charset=utf-8"
      }
    },
    "scenarios": {
      "waf_block": {
        "statusCode": 403,
        "title": "请求被拦截",
        "message": "如需协助，请向网站管理员提供请求 ID。"
      },
      "ip_deny": {
        "statusCode": 403,
        "title": "访问被拒绝",
        "message": "当前访问不被允许。"
      },
      "country_deny": {
        "statusCode": 403,
        "title": "访问被拒绝",
        "message": "当前访问不被允许。"
      },
      "rate_limit": {
        "statusCode": 429,
        "title": "请求过于频繁",
        "message": "请稍后重试。"
      },
      "bot_block": {
        "statusCode": 403,
        "title": "需要浏览器验证",
        "message": "请使用 HTTPS 浏览器访问；API 接入请联系网站管理员。"
      },
      "service_unavailable": {
        "statusCode": 503,
        "title": "服务暂时不可用",
        "message": "请稍后重试。"
      }
    }
  }
}
JSON
sudo tiyi system settings get > settings-before.json
jq '{"security.responses.config": .settings.values["security.responses.config"]}' \
  settings-before.json > responses-before.json
sudo tiyi system settings update --values-json "$(cat security-responses.json)"
```

只有 `security.responses.config` 这个键会更新。该对象必须包含全部格式和六个场景，即使某个格式没有启用。
不要继续写旧版分散的 WAF/限速响应键，IP/国家绑定也没有单独状态码选项。

## 3. 验证与恢复

在自己的演示站点分别请求 HTML 和 JSON：

```sh
curl -i --get -H 'Host: quickstart.test' -H 'Accept: text/html' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
curl -i --get -H 'Host: quickstart.test' -H 'Accept: application/json' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
```

两次都应为配置的 WAF 状态码，正文格式与 Content-Type 应匹配，响应包含太一生成的请求 ID。
正常请求仍应到达源站。多节点检查每个服务节点的发布结果。
恢复前检查 `responses-before.json` 中的值是完整对象而不是 null，再执行：

```sh
sudo tiyi system settings update --values-json "$(cat responses-before.json)"
```

若原配置未显式保存、备份值为 null，可在控制台点击重置默认值，再保存；重置编辑器但不保存不会影响在线配置。

## 4. 支持的变量与边界

模板仅支持 `{response.status_code}`、`{response.kind}`、`{response.source}`、`{response.title}`、
`{response.message}`、`{request.id}`、`{request.time}`。来源是固定的大类，ID/时间由太一生成。
不支持嵌入请求 Cookie、正文、IP、路径、规则 ID、阈值、内部错误或剩余封禁时间。
未知变量和无效 JSON 会拒绝保存/应用；运行时保留最后有效配置。
模板不支持 JavaScript，终止响应有禁止脚本的 CSP；不要粘贴依赖脚本的完整页面。
太一不会自动发送 `Retry-After`，客户端应使用自己的有界重试策略。
