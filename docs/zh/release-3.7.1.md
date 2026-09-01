# 太一 v3.7.1 发行说明

发布日期：2026-09-01。v3.7.1 是沿用 v3.7 状态契约的兼容加固版本。

## 主要变化

- **新站点默认 Built-in Light：**新建站点默认使用 Light。CRS 攻击评分、multipart
  校验、请求体上限和参数/上传护栏继续执行；未列出的 MIME 与 JSON/XML 解析失败
  改为不拦截的兼容性观察。Connect RPC 帧按原始数据处理。
- **保留现有策略行为：**绝不迁移已有站点绑定；Standard 对 MIME/解析器的严格拦截
  行为保持原样。
- **可运维 IP 列表关系：**手动列表和订阅行展示有界的动作/目标摘要；
  **管理应用**加载完整关系，可停止普通访问绑定而不删除共享内容，并把规则/信任
  消费者链接到归属配置。
- **安全的私网示例：**新安装包含一个普通、可编辑的手动列表，预置 RFC 1918 IPv4
  与 IPv6 ULA `fc00::/7`。它没有绑定、不会自动成为可信来源，并可正常编辑或删除。
- **准确的采样告警：**单客户端公平采样仍在管道诊断中可见，但不再触发全局
  “观测采样压力”告警；真实全局预算或队列压力仍会触发。

## 升级

v3.7.0 安装可使用常规签名更新流程：

```sh
sudo tiyi update --check
sudo tiyi update --yes                 # GitHub，失败自动回退 Gitee
sudo tiyi update --yes --mirror gitee # 或强制 Gitee
sudo systemctl restart tiyi
tiyi --version
sudo tiyi system health
```

若从 v3.6.0 或更早状态进入 v3.7 系列，先前的干净状态边界仍然适用；过渡前请阅读
[升级与迁移](upgrade-migration.md)。

二进制、`SHA256SUMS`、Ed25519 签名与发行清单见
[GitHub Release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.1) 与
[Gitee 镜像](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.1)。
