# 导入、导出与迁移站点

适用版本：**v3.8.0**。想从文件创建站点，使用下方模板；想搬迁已有站点，优先让太一导出完整配置。
只迁移站点无需拷贝数据库。要搬迁整个 Controller，使用[完整备份与恢复](upgrade-migration.md)。

## 1. 可以直接编辑的导入模板

准备可访问的源站 `http://127.0.0.1:9000`，或替换为你的地址。为避免意外接管流量，模板把新站点设为**停用**。
`imported.example.com`、站点名称、上游名称需要在目标实例中未被使用。下载版：[site-import.json](templates/site-import.json)。

```sh
umask 077
cat > site-import.json <<'JSON'
{
  "apiVersion": "tiyi.io/v1",
  "kind": "SiteConfiguration",
  "site": {
    "name": "imported-app",
    "primaryHost": "imported.example.com",
    "upstreams": [
      {
        "upstreamId": "00000000-0000-4000-8000-000000000010"
      }
    ],
    "tls": {
      "mode": "TLS_MODE_NONE"
    },
    "waf": {
      "enabled": true,
      "mode": "WAF_MODE_BLOCKING"
    },
    "status": "RESOURCE_STATUS_DISABLED"
  },
  "upstreams": [
    {
      "id": "00000000-0000-4000-8000-000000000010",
      "name": "imported-origin",
      "endpoints": [
        {
          "url": "http://127.0.0.1:9000",
          "weight": 100
        }
      ],
      "status": "RESOURCE_STATUS_ACTIVE"
    }
  ],
  "routing": {
    "unmatchedAction": "UNMATCHED_PATH_ACTION_DEFAULT_UPSTREAM"
  },
  "containsSecrets": false
}
JSON
sudo tiyi site import site-import.json
sudo tiyi site list
```

控制台等价操作：**应用交付 → 站点 → 导入**，上传同一 JSON 文件。
导入成功会返回新 `site.id`、创建的上游数量及警告。复制返回的 ID：

```sh
SITE_ID='替换为导入返回的 site.id'
sudo tiyi site get "$SITE_ID"
sudo tiyi site enable "$SITE_ID"
curl -i -H 'Host: imported.example.com' http://127.0.0.1/
```

预期正常源站响应。测试 HTTPS 站点时使用 `curl --resolve 域名:443:太一IP https://域名/`，不要用 `-k` 跳过证书校验。

## 2. 哪些字段需要修改

| 字段 | 如何填写 |
|---|---|
| `apiVersion`、`kind` | 保持 `tiyi.io/v1`、`SiteConfiguration` |
| `site.name` / `primaryHost` / `aliases` | 新站点名称、主域名和可选别名；域名不带协议、端口或路径，主域名和别名均支持[一级通配域名](operations.md#wildcard-hosts) |
| `upstreams[].id` 与 `site.upstreams[].upstreamId` | 文件内引用，两个值必须一致；导入后自动分配新 ID，示例 UUID 可以保留 |
| `upstreams[].endpoints[].url` | 从服务节点可访问的完整源站 URL，包含 `http://` 或 `https://` 和必要端口 |
| `site.waf` | 本例启用阻断并省略 `policyId`，自动用内置 Light；自定义策略需先在目标实例存在 |
| `site.status` | `RESOURCE_STATUS_DISABLED` 先检查后启用；`RESOURCE_STATUS_ACTIVE` 会直接发布 |
| `routing` | 本例走默认上游；实际多路径站点请导出其路由配置后修改 |

通配站点可将 `primaryHost` 填为 `"*.example.com"`；接入根域名时在 `aliases` 中另加 `"example.com"`，使用 OpenAPI/Schema 映射时另加 `"api.example.com"` 等具体 API 域名。`a.b.example.com` 等更深层级需要单独的具体域名或通配模式。HTTPS 证书须覆盖全部已配置域名。

这里的枚举是 API 格式，与 `tiyi apply` 的 `active`、`none` 等短值不同。
此文件属于**站点配置包**，不能给 `tiyi apply`，OpenAPI 文档也不能给 `site import`。

## 3. 导出已有站点

在源端查询 ID，然后执行：

```sh
sudo tiyi site list
sudo tiyi site export SITE_ID -o site-backup.json
sudo tiyi site export -o all-sites.json
```

无 ID 导出全部未删除站点为 `SiteConfigurationArchive`；单站点是 `SiteConfiguration`。
两种文件都可用 `sudo tiyi site import FILE` 导入。导出默认创建权限 0600 的文件，已存在时拒绝覆盖，
只有明确需要替换才用 `--force`。传输与编辑应保持文件私密。

配置包包含站点、引用的上游池、路径路由、站点策略标量覆盖、上游请求头，以及选定的 TLS 证书和私钥。
**它不是完整安装备份**：WAF 策略仍为外部引用；自定义规则、共享 IP 列表、API 文档与学习版本、
告警、账号、ACME 账号等应在目标端单独核对/重建。Bot 引用的 IP 列表也须存在。
即使 `containsSecrets` 为 false，上游请求头仍可能含敏感信息，不能据此公开文件。

## 4. 迁移前后要核对什么

1. 在目标端先准备被引用的 WAF 策略、列表及依赖；跨版本先核对兼容性。
2. 检查新主机到每个源站的连通性、域名冲突和证书范围；需要时将导出文件内站点改为停用后导入。
3. 导入会创建新 ID，**不会覆盖**目标资源；相同域名、上游名或证书指纹冲突会明确报错。
4. ACME 托管证书导入后成为上传证书，不会继承自动续期账号。需要自动续期时在目标端重新签发并绑定托管证书。
5. 启用后验证所有域名、路由、TLS、正常请求和 WAF，再切换 DNS。记录旧实例作为回退点。

批量归档逐站点导入；中间失败会保留前面成功的站点，并报告进度，失败站点创建的资源会清理。
修正后只重试未成功的条目，直接重复整个归档可能碰到已存在冲突。不要假设全归档是一个事务。
