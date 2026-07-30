# 把旧安装切换到太一 v3.4.0

太一 v3.4.0 是采用干净状态的单 Controller 发行版。它会明确拒绝 schema 低于 47
的状态数据库，而不是猜测如何转换旧 Controller 角色、本机 Agent 身份、复制状态或
旧配置投递记录。

## 重置前保留

导出或保存仍需重建的站点、上游、策略、用户和密钥源清单。把上传证书源文件、
license 文件和 KEK 与旧状态一起备份。归档数据库只用于回滚或分析；v3.4.0
无法打开它。

## Controller

```sh
sudo systemctl stop tiyi

# 完整保留旧状态；若使用自定义状态路径，请替换这里的路径。
sudo mv /var/lib/tiyi /var/lib/tiyi.pre-v3.4
sudo install -d -m 0750 /var/lib/tiyi

sudo tiyi install --now
sudo systemctl status tiyi --no-pager
tiyi system health
```

不要把旧 `state.db`、观测/明细分区、身份标记或缓存 bundle 复制到新目录。

## 远程 Agent

先从 unit/配置确认实际路径，再删除每个旧开发/测试 Agent 的身份与缓存 bundle
状态。随后打开**节点 → 安装远端节点**，签发新的一次性 Token，并让 Agent 重新
注册到唯一稳定的 Controller URL。

```sh
systemctl cat tiyi-agent
sudo journalctl -u tiyi-agent -n 100 --no-pager
```

## 验收

1. `tiyi --version` 显示 `v3.4.0`。
2. `tiyi system health` 健康，节点页显示本机内置节点。
3. 重建一个站点，发送一次正常请求和一次 CRS 测试请求。
4. 确认精确请求/拦截计数，并可按 `X-Request-Id` 查询。
5. 确认所有远程 Agent 在线且已应用当前 revision。
