# 太一 v3.7.2 发行说明

发布日期：2026-09-03。v3.7.2 是沿用 v3.7 状态契约的兼容运维补丁。

## 主要变化

- **总览防护链路：**一次未过滤的执行摘要把八个来源折叠成请求真实经过的五个
  阶段——Bot 准入 → 限速/挑战 → IP/国家 → 资源护栏 → WAF/CRS → 源站。每个阶段
  给出配置姿态、决策、故障优先原因与动作拆分。Bot 阶段打开**日志 → Bot 分析**；
  其他阶段打开已过滤的**日志 → 执行分析**。KPI 使用可验证契约
  `terminated = blocked/rejected/banned + challenged`。
- **Bot 分析：** **日志 → Bot 分析**从 Observation V2 计数平面记录固定基数的
  准入结果：路径/可信 IP 豁免、Clearance 命中、挑战签发/通过/失败、不支持的
  客户端与内部失败。成功准入不是执行决策。页面不声称识别了 Bot，也不计算访客
  通过率。
- **可读的请求证据：**控制台预览先显示方法、精确请求目标和客户端 HTTP 版本，
  再显示 Host 与捕获的请求头。安装 GeoIP 数据后，客户端 IP 可显示参考性网络
  区域标签。
- **SecLang 引号：**路径范围的 CRS 排除、规则目标更新和可视化规则正则现在原样
  到达 Coraza，作者写的 `\.` / `\d` 不再被二次转义。

## 升级

v3.7.1 与 v3.7.0 安装可使用常规签名更新流程：

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
[GitHub Release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.2) 与
[Gitee 镜像](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.2)。
