# CLI 任务参考

适用版本：**v3.8.0**。在太一主机上，系统服务使用受权限保护的本地 socket：通常加 `sudo` 即可，不用登录。
远程 CLI 使用[API 指南](api.md#authentication)取得的 `TIYI_API` 和 `TIYI_TOKEN`，然后省略 sudo。
自定义前台进程使用 `--admin-socket /实际路径/admin.sock`。

## 常用只读检查

```sh
sudo tiyi system health
sudo tiyi site list
sudo tiyi upstream list
sudo tiyi cert list
sudo tiyi policy list
sudo tiyi agents list
sudo tiyi audit verify
```

列表和资源操作通常输出 JSON；保存命令输出后可用 `jq` 提取 ID。不要凭空编造 ID，先 list/get。
日志列表可分页，默认第一页不代表全部记录。CLI 出错返回非零；普通失败为 1，Agent 注册需要重置/被拒绝时为 78。
`system health` 在 unhealthy/unknown 时也返回非零，自动化要检查退出状态。

## 按任务找命令

| 任务 | 命令组 | 完整操作说明 |
|---|---|---|
| 安装、启动、诊断 | `install`、`run`、`doctor` | [安装](installation.md) |
| 站点、路径路由、迁移 | `site`、`site routing`、`site export/import` | [运维](operations.md) · [导入 JSON 模板](site-import.md) |
| 源站池、健康探测、重试 | `upstream` | [运维](operations.md) |
| 上传证书、ACME、DNS 凭据 | `cert` | [HTTPS](operations.md#https) |
| WAF 策略、版本、请求容量 | `policy` | [调优](operations.md) |
| 自定义规则、CRS 覆盖、IP/国家、限速 | `rule`、`crs` | [运维](operations.md) |
| 客户端 IP/CDN 可信代理 | `trust` | [部署](deployment.md#client-ip) |
| API 文件、学习、校验、发布 | `api-document` | [API 防护](api-protection.md) |
| 请求调查、告警、通知、审计 | `log`、`alert`、`audit` | [运维](operations.md) |
| 远端节点、节点分组 | `agents`、`agent-group` | [部署](deployment.md#nodes) |
| 身份、用户、角色 | `auth`、`user`、`role` | [API](api.md) · [部署](deployment.md) |
| 文件化资源管理 | `get`、`diff`、`apply` | [YAML 模板](configuration.md) |
| 系统设置、更新、节点升级 | `system`、`update`、`release` | [升级与迁移](upgrade-migration.md) |

## 常用写入示例

操作自己的资源前先 list/get 核对目标。以下文件均有完整模板：

```sh
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
sudo tiyi site import site-import.json
sudo tiyi api-document upload --site SITE_ID --file orders-openapi.yaml
```

`first-site.yaml` 用于 apply；`site-import.json` 用于站点导入；`orders-openapi.yaml` 用于 API 文档。
三者不能混用。新增 CLI 资源通常立即生效；`diff`、`--dry-run` 和文档预览才是预览步骤。

## 通配域名建站

`site create` 和 `site update` 的 `--host`、可重复的 `--alias` 都支持通配域名。通配值要加引号，例如 `--host '*.example.com' --alias example.com`。通配符只匹配一级子域名；根域名需要单独添加，`a.b.example.com` 等多级子域名不会匹配。完整命令及 HTTPS/API 要求见[通配域名建站](operations.md#wildcard-hosts)。

## 查准确参数

不用翻源码：本站同时提供[完整命令与参数参考](../reference/cli-options.md)。
安装版本也随二进制带完整帮助：

```sh
tiyi --help
tiyi site create --help
tiyi site routing set --help
tiyi api-document --help
tiyi api-document preview --help
tiyi alert channel upsert --help
```

CLI 的 `api-document -f` 请求字段使用 protobuf JSON，完整字段见[API 方法表](../reference/services/api_schema.md)。
没有专用 CLI 的操作可使用 UI 或 HTTP JSON API，不需要直接编辑数据库或生成的代理配置。
