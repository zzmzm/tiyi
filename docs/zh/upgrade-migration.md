# 升级与迁移太一

先按目标选择流程：

| 目标 | 流程 |
|---|---|
| 在原主机安装兼容的签名版本 | 备份 → `tiyi update --yes` → 重启 → 验证 |
| 不改变状态格式，把 Controller 搬到新主机 | 停止源端 → 完整复制状态和配置 → 在目标端用相同版本启动 |
| 安装无法读取当前状态的版本 | 备份 → `uninstall --purge` → 用保留的二进制更新 → `install --now` → 重新配置 |

更新器只验证发行元数据、校验和与签名，没有硬编码最低版本，也不替代数据兼容性判断。
更新前应阅读目标版本说明，并先保存可回滚副本。

## 日常签名更新

目标版本的状态与 Agent 协议兼容时：

```sh
tiyi --version
sudo tiyi update --check
sudo tiyi update --yes                 # GitHub，失败自动回退 Gitee
sudo tiyi update --yes --mirror gitee # 或强制 Gitee
sudo systemctl restart tiyi
tiyi --version
sudo tiyi system health
sudo journalctl -u tiyi -b -n 200 --no-pager
```

`update` 验证成功后原子替换 `/usr/local/bin/tiyi`，但不会重启正在运行的进程。

## 状态不兼容的更新

v3.6.0 无法读取更早版本创建的数据库。完成这一次过渡时，应把旧安装保存为离线
回滚归档，并用空状态和空配置启动。不要把旧归档导入新的在线路径。

### 1. 停止并归档

```sh
tiyi --version
systemctl cat tiyi
sudo systemctl stop tiyi

stamp=$(date -u +%Y%m%dT%H%M%SZ)
sudo install -d -m 0700 /var/backups/tiyi
sudo tar --xattrs --acls -C / \
  -czf "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz" \
  var/lib/tiyi \
  etc/tiyi \
  etc/systemd/system/tiyi.service \
  usr/local/bin/tiyi
sudo sha256sum "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz"
sudo tar -tzf "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz" | head
```

若二进制、状态、配置、license、证书或密钥使用了自定义路径，把它们加入归档。
归档和校验和必须放在太一在线目录之外。归档可能包含私钥、密码、Token、请求证据和
个人数据，应按密钥等级保护。

### 2. purge、更新并安装

`uninstall --purge` 会删除服务 unit、`/var/lib/tiyi`、`/etc/tiyi` 和服务账号，
但有意保留 `/usr/local/bin/tiyi`，因此旧二进制可以把同一个文件替换为已验证版本：

```sh
sudo /usr/local/bin/tiyi uninstall --purge
sudo /usr/local/bin/tiyi update --yes --mirror gitee
/usr/local/bin/tiyi --version
sudo /usr/local/bin/tiyi doctor --mode run
sudo /usr/local/bin/tiyi install --now
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -b -n 200 --no-pager
sudo /usr/local/bin/tiyi system health
```

若保留的二进制没有 `update` 命令，先验证归档，只删除那个准确的二进制路径，再运行
公开安装器。保存新的一次性管理员密码，重新创建审核过的站点、策略、证书、认证、
信任、SIEM 和告警配置；目标协议要求时，重新注册远程 Agent。

## 把 Controller 迁移到另一台主机

两台主机应尽量使用**完全相同的太一版本**。只有目标版本说明明确声明状态兼容时，
才可以直接迁移到更新版本；单向 schema 变化应先在隔离副本上测试。

必须复制**完整状态目录**，不能只复制 `state.db`。`/var/lib/tiyi` 还可能包含 SQLite
WAL 文件、默认 KEK、日志/明细分区、请求证据、CRS 数据、发行制品、生成 bundle 和
内嵌 Agent 身份。同时复制 `/etc/tiyi`，以及配置引用的外部 KEK、license、证书和
密钥文件。

### 1. 获取一致的源端归档

```sh
tiyi --version
systemctl cat tiyi
sudo systemctl stop tiyi
stamp=$(date -u +%Y%m%dT%H%M%SZ)
sudo install -d -m 0700 /var/backups/tiyi
sudo tar --xattrs --acls -C / \
  -czf "/var/backups/tiyi/tiyi-migrate-${stamp}.tar.gz" \
  var/lib/tiyi etc/tiyi
sudo sha256sum "/var/backups/tiyi/tiyi-migrate-${stamp}.tar.gz"
```

生成最终归档后不要再启动源端。记录自定义 unit 选项、drop-in 与注入的环境变量，
再通过有认证的通道传输归档和校验和。

### 2. 在干净目标主机恢复

安装同一签名版本，先创建服务账号和 unit，但不要启动。把 `vX.Y.Z` 和归档文件名
替换为源端准确值：

```sh
source_tag=vX.Y.Z
archive=/secure/path/tiyi-migrate-YYYYMMDDTHHMMSSZ.tar.gz
curl -fsSL https://www.tiyisec.com/install.sh \
  | TIYI_VERSION="$source_tag" bash
sudo /usr/local/bin/tiyi install

sudo sha256sum "$archive"
sudo tar --xattrs --acls -C / -xzf "$archive"
sudo chown -R tiyi:tiyi /var/lib/tiyi
sudo chgrp -R tiyi /etc/tiyi
sudo chmod -R g+rX /etc/tiyi

sudo /usr/local/bin/tiyi doctor --mode run --fix-state-ownership
sudo /usr/local/bin/tiyi install --now
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -b -n 200 --no-pager
sudo /usr/local/bin/tiyi system health
```

解压前先把目标端校验和与源端记录值进行比较。在运行 `doctor` 前重建审核过的 unit
定制并恢复所有外部文件，保证 `tiyi` 服务用户可读。启动后检查站点、
证书、远程 Agent 状态、当前 bundle revision、`tiyi audit verify` 和本地 `/metrics`。

严禁源端与克隆的 Controller 同时运行：它们共享部署身份、签名密钥和 Agent 信任。
回滚时必须先停止目标端，再启动未改动的源端。两边一旦都接受过写入，不能合并两份
状态树。

## 排查失败

```sh
sudo /usr/local/bin/tiyi doctor --mode run
systemctl status tiyi --no-pager
journalctl -u tiyi -b -n 200 --no-pager
journalctl -u tiyi -f
ss -ltnp
```

- 安装器拒绝表示新主机安装器发现了已有二进制、状态、配置或 unit，应改用升级或
  迁移流程。
- schema 不兼容表示目标二进制无法读取该状态；停止服务，改用匹配的二进制，或恢复/
  重置预期状态。
- sudo 下 `command not found` 通常是 `secure_path` 未包含安装目录；请明确使用
  `/usr/local/bin/tiyi`。
- 更新失败不会破坏现有二进制；修复镜像、网络、磁盘空间或权限后重试。

Prometheus 接入见[日常运维：接入 Prometheus](operations.md#7-接入-prometheus)，
其他问题见[排障](troubleshooting.md)。
