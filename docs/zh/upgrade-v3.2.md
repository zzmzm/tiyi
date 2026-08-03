# 把开发或测试环境切换到 v3.2

太一 v3.2 引入 observation-v2 存储与 Agent 协议。项目目前没有需要兼容的正式用户
升级群体，因此本版本采用干净状态切换，不迁移旧观测数据。

## 必须重置的内容

- v3.1 或更早的 `state.db` 会在启动时被拒绝。
- 旧 Agent 身份标记与缓存配置 bundle 会被拒绝。
- 历史明细数据库和 spool 文件不会导入 v3.2。

请通过声明式清单或 Web UI 重新创建配置。删除旧测试状态前，保留仍需使用的源
YAML、证书、license 文件与 KEK。

## Controller

```sh
sudo systemctl stop tiyi

# 仅适用于开发/测试数据；如需分析请先保留备份。
sudo mv /var/lib/tiyi /var/lib/tiyi.pre-v3.2
sudo install -d -m 0750 /var/lib/tiyi

sudo tiyi install --now
sudo systemctl status tiyi --no-pager
tiyi system health
```

若使用自定义路径，请移动配置中的状态数据库、观测/明细目录与本地 spool，而不是
固定照抄 `/var/lib/tiyi`。v3.2 启动后不要再复制回旧数据库。

## Agent

重置每个开发/测试 Agent 的本地身份与观测状态，然后从 v3.2 Server 签发新注册
token 并重新注册。删除前先通过已安装 unit/配置确认实际路径：

```sh
systemctl cat tiyi-agent
sudo journalctl -u tiyi-agent -n 100 --no-pager
```

重新注册后，在 **Fleet → Agents** 或 `tiyi agents list` 中确认 Agent 在线且已应用
最新 revision。

## 验收

1. `tiyi --version` 显示 `v3.2.0`。
2. `tiyi system health` 为健康。
3. 创建一个站点，发送一次正常请求与一次 CRS 测试请求。
4. 确认精确请求/拦截计数、SecurityFact，并可按 `X-Request-Id` 跨流查询。
5. 确认所有远程 Agent 在线，journal 中不再出现旧格式错误。
