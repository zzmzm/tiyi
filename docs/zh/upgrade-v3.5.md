# 把已有太一安装升级到 v3.5.0

主机只要运行过 v3.4.0 或更早版本，升级到太一 v3.5.0 就必须**完整卸载并全新
安装**。这不是原地状态迁移。该流程会主动删除旧 Controller 数据库、日志、KEK、
证书、配置、systemd unit 和服务身份。

> **高危且不可逆：**`sudo tiyi uninstall --purge` 会删除
> `/var/lib/tiyi` 与 `/etc/tiyi` 下的全部太一历史和配置，同时移除 systemd unit、
> `tiyi`/`tiyi-admin` 服务用户与组。任何仍需使用的信息都必须在继续前记录或导出，
> 并完成下面的备份。本指引不提供回滚操作。

## 为什么 update 后重启会失败

`sudo tiyi update --yes --mirror gitee` 会正确下载、校验并替换磁盘上的二进制，但它
不会重启正在运行的服务，也不会让旧状态自动兼容。

正式发布的 v3.4.0 状态在 v3.5.0 重启时会出现类似错误：

```text
store: migration 0016_telemetry_rollups.sql sha256 drift ...
```

更早的状态可能显示：

```text
store: clean-break state reset required (schema=..., minimum=47) ...
```

不要反复重启，也不要把旧数据库复制回来。必须完整删除旧安装，再让 v3.5.0 创建
全新状态。

## 1. 记录需要重建的内容

执行 purge 前，只记录后续准备重建的配置：

```sh
tiyi version
sudo systemctl status tiyi --no-pager
sudo systemctl cat tiyi
sudo tiyi site list
sudo tiyi upstream list
sudo tiyi policy list
sudo tiyi cert list
sudo tiyi agents list
sudo tiyi user list
```

同时记录自定义监听地址、DNS、上游、WAF 调优、证书源文件、license 路径、身份
提供商设置、SIEM 目标和远程 Agent 名称。不要把密码、私钥、Token、KEK、license
内容或捕获的请求数据粘贴到工单或聊天中。

第 3 步 purge 会删除全部旧事件、流量历史、审计历史、用户、策略、上传证书、
Agent 注册和本机密钥。

## 2. 完整备份旧安装

复制 SQLite 状态及关联文件前必须先停止服务。以下默认路径示例把状态、配置和
unit 定义保存在同一备份目录：

```sh
TIYI_BACKUP_DIR="/var/backups/tiyi-pre-v3.5-$(date +%Y%m%d-%H%M%S)"

sudo systemctl stop tiyi
sudo install -d -m 0700 \
  "$TIYI_BACKUP_DIR/state" "$TIYI_BACKUP_DIR/config"
sudo cp -a /var/lib/tiyi/. "$TIYI_BACKUP_DIR/state/"
sudo cp -a /etc/tiyi/. "$TIYI_BACKUP_DIR/config/"
sudo systemctl cat tiyi | sudo tee "$TIYI_BACKUP_DIR/tiyi.service" >/dev/null

sudo test -f "$TIYI_BACKUP_DIR/state/state.db"
sudo ls -ld "$TIYI_BACKUP_DIR"
```

如果 `store.state_db`、`crypto.kek_file`、证书源文件、license、日志分区、配置或
服务环境文件使用自定义路径，必须把这些实际路径加入备份，并在继续前逐项验证。

备份中含有凭据和未脱敏的运营历史。仅允许 root 访问，加密保存，并转移到运维方
控制的存储。它只用于历史留存和人工重建；不要把其中的旧 `state.db` 或日志分区
复制到 v3.5.0 状态目录。

## 3. 完整卸载旧版本

使用当前已安装的二进制执行交互式清除：

```sh
sudo tiyi uninstall --purge
```

阅读警告，只有在接受全部数据丢失后才输入 `yes`。不要在自动化中附加 `--yes`；
本次升级必须保留明确的高危确认。

完成后，下列内容均已删除：

- `tiyi.service` 及其 systemd 启用状态；
- `/var/lib/tiyi`，包括 `state.db`、日志、KEK、上传资产和生成的运行状态；
- `/etc/tiyi`，包括 YAML 配置和受保护的环境文件；
- `tiyi` 服务用户/组与 `tiyi-admin` socket 组。

二进制本身仍在。因为 unit 已经被删除，下一条命令**不能**是
`sudo systemctl restart tiyi`。

## 4. 安装签名的 v3.5.0 二进制

使用 Gitee 镜像：

```sh
curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh \
  | TIYI_MIRROR=gitee TIYI_VERSION=v3.5.0 bash
tiyi version
```

或使用官网/GitHub 路径：

```sh
curl -fsSL https://www.tiyisec.com/install.sh \
  | TIYI_VERSION=v3.5.0 bash
tiyi version
```

版本输出必须是 `v3.5.0`。如果之前已经执行过 `tiyi update`，且
`tiyi version` 已显示 `v3.5.0`，可以跳过再次下载；完整 purge 和全新服务安装仍是
必需步骤。

## 5. 创建并启动全新服务

先预览新 unit，再安装并启动：

```sh
tiyi doctor --no-color
tiyi install --print
sudo tiyi install --now
sudo systemctl status tiyi --no-pager
sudo tiyi system health
```

`tiyi install --now` 会重新创建服务身份、配置/状态目录、加固 systemd unit 与全新
Controller 数据库，并打印新的一次性管理员密码。请安全保存；旧用户和密码已经
不存在。

如需自定义端口或配置，必须在接回生产流量前重新设置，并再次运行 `tiyi doctor`。

## 6. 重建配置并重新注册 Agent

通过受支持的 Web UI 或 CLI 重建站点、上游池、证书、WAF 策略、用户/RBAC、告警
通道、SIEM 目标、身份提供商和授权配置。不要恢复旧 `state.db` 或旧日志分区。

全新 Controller 使用新的身份和签名状态。每个远程 Agent 都必须重新注册：

1. 打开**节点 → 安装远端节点**。
2. 签发新的一次性 Token。
3. 如果 Agent 主机仍使用旧版本，完整删除旧 Agent 服务和状态。
4. 执行页面新生成的 v3.5.0 Agent 安装命令。
5. 确认 Agent 在线并已应用当前 revision/hash。

不要复用旧注册 Token、身份标记或缓存 bundle。

## 7. 验收

接回流量前完成全部检查：

1. `tiyi version` 显示 `v3.5.0`。
2. `systemctl status tiyi` 为 active，`tiyi system health` 健康。
3. 新管理员可以登录并修改一次性密码。
4. 每个站点的正常 Host/SNI 请求都进入正确上游。
5. 受控 CRS 探针被拦截且响应不为空。
6. TLS 证书有效并绑定到目标站点。
7. 请求/拦截计数正常，并可按 `X-Request-Id` 查询。
8. 每个远程 Agent 都已重新注册、在线并处于预期 revision。
9. 审计链和日志管道健康，没有异常失败。

如果服务仍然启动失败，收集 `systemctl status tiyi` 与
`journalctl -u tiyi -n 200 --no-pager`。查明新错误前不要再次执行 purge。
