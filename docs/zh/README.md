# 太一文档

太一是单二进制应用网关：Caddy 终止并代理请求，Coraza 与 OWASP CRS 完成检测，
内嵌控制平面记录结果。请按当前任务选择文档，而不是从头通读。

## 选择一条路径

| 目标 | 从这里开始 |
|---|---|
| 安装单节点并验证一次真实拦截 | [快速开始](getting-started.md) |
| 发布站点、调优 WAF、调查流量与运维 Agent | [日常运维](operations.md) |
| 排查启动、路由、TLS、WAF、登录、Agent 或遥测问题 | [排障](troubleshooting.md) |
| 把开发/测试环境切换到 v3.2 | [v3.2 状态重置](upgrade-v3.2.md) |
| 浏览完整 CLI、API、部署和概念参考 | [tiyisec.com/docs](https://www.tiyisec.com/zh/docs/) |

## 一次请求如何流过太一

```text
客户端 -> 监听/TLS -> 站点 + 路径路由 -> WAF 策略 -> 上游
                          |                   |
                          +-> 访问事实         +-> Finding/Incident
                                                  -> Campaign/告警/SIEM
```

调查时先固定站点、时间范围和 `X-Request-Id`。太一把数据面的精确计数、保留证据与
外部投递拆开，因此 SIEM 不可用或分析任务变慢都不会阻塞代理流量。

## 支持的运维入口

- **Web UI**：适合有引导的配置与可视化调查。
- **本地 CLI**：通过 root 管理的 Unix socket；同机且具备 socket 权限时无需 JWT。
- **远程 CLI/API**：通过 ConnectRPC，使用 `--api` 与 `--token`。
- **声明式配置**：先 `tiyi diff -f FILE`，再 `tiyi apply -f FILE`。

运行 `tiyi <命令> --help` 查看已安装二进制支持的准确参数。若参考文档与二进制
不一致，以二进制为准。

