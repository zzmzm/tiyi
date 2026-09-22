# 太一文档

太一把反向代理、HTTPS、Web/API 防护和管理控制台放进一个可执行文件。这些文档从第一次启动写起，带你接入网站、查看防护结果，再逐步完成生产部署和日常运维。

## 从这里开始

第一次使用，从[快速开始](getting-started.md)开始就好。安装、登录、创建第一个站点，再看 WAF 拦截真实攻击；完成后，可以继续[实战与进阶](practice.md)中的练习，或在[日常运维](operations.md)中接入自己的应用。

新 Linux 主机使用默认端口，一行安装并启动系统服务：

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

网站默认使用 80/443，管理控制台使用 8080。首次密码会显示在终端；HTTPS 需要配置站点和证书。
需要[手动分步](getting-started.md#manual)、[自定义端口](getting-started.md#custom-ports)或[离线安装](getting-started.md#offline)时，快速开始也有对应步骤。
已有安装请先阅读[升级与迁移](upgrade-migration.md)。

## 使用指南

- [安装](installation.md)：安装与校验发行包，管理系统服务，选择适合自己的运行方式。
- [配置与模板](configuration.md)：完整的启动配置与建站 YAML，附写入、应用和验证步骤。
- [站点导入与导出](site-import.md)：用文件接入或迁移站点，处理冲突与证书。
- [API 与上传防护](api-protection.md)：导入 OpenAPI、学习 JSON 结构，用真实请求验证校验结果。
- [防护响应](responses.md)：调整拦截页面、状态码和 API 错误格式。
- [工作方式](concepts.md)：了解站点、上游、证书、策略与节点如何配合。
- [CLI](cli.md) 与 [API](api.md)：从认证和调用示例开始编写自动化；也可[安装 AI 运维技能](../../README.zh-CN.md#ai-agent-skill)。
- [生产部署](deployment.md)与[备份恢复](upgrade-migration.md#backup)：准备上线、接入监控、扩展节点，并演练恢复。
- [排障](troubleshooting.md)：按启动、登录、路由、TLS 或防护现象找到下一步检查。

## 模板与完整参考

[启动 tiyi.yaml](templates/tiyi.yaml) · [最小建站 YAML](templates/first-site.yaml) · [四类资源 YAML](templates/apply.yaml) ·
[站点导入 JSON](templates/site-import.json) · [OpenAPI YAML](templates/orders-openapi.yaml) · [本机测试 API](templates/demo-origin.py) ·
[拦截响应 JSON](templates/security-responses.json)。

[全部 RPC](../reference/rpc-index.md) · [权限](../reference/permissions.md) · [全部 CLI 参数](../reference/cli-options.md)。

**已有安装升级到 v3.8.0 必须先备份并重建状态，重新注册所有远端 Agent。**
请先阅读[v3.8.0 版本说明](release-3.8.0.md)与[迁移步骤](upgrade-migration.md)，不要直接替换二进制后重启。
历史说明：[v3.7.2](release-3.7.2.md) · [v3.7.1](release-3.7.1.md) · [v3.7.0](release-3.7.0.md)。
