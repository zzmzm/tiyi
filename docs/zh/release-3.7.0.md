# 太一 v3.7.0 发行说明

发布日期：2026-08-31。v3.7.0 是自适应防护与信任拓扑版本。

## 主要变化

- **站点级 Bot 防护：**仅 HTTPS 站点可保持关闭、运行静默浏览器工作量证明，或在
  浏览器证明后要求私密 WebAuthn 设备确认。运维人员可控制窄范围路径豁免、可信 IP
  列表引用、clearance TTL、证明难度与网络绑定。
- **因果 WAF 过载处理：**每个节点把归一化太一进程 CPU 与实测 Coraza 需求关联。
  默认继续完整检查；明确配置后可快速返回带原因标记的 503，或只绕过 CRS，同时保留
  原生 IP、国家、限速与 body 控制。执行遥测记录准确结果。
- **IP Lists v2 与 Country Access：**手动列表、文件导入、provider feed、自定义订阅、
  JSONPath 提取、原子快照、删除比例 hold 与 last-good 消费者编译统一到一个列表模型。
  国家策略改用由 active Country 数据库支撑的独立资源，拒绝 `geo:*` 伪条目。
- **滚动窗口滥用控制：**端点与客户端类别限速获得确定性滚动窗口、站点/全局临时封禁
  和独立浏览器挑战 profile。WAF 与限速拦截响应改为互相独立的模板。
- **通用客户端 IP 信任拓扑：**命名代理节点使用普通手动或订阅 IP 列表，并表达
  Header-first 信任边。拓扑分析生成待审核草案，不会静默信任 provider feed。
- **压力下的有界观测：**客户端公平的 SecurityFact 采样、分离的过载/覆盖信号、
  持久 Country 激活状态与完整 CRS 文件清单，让高输入量和外部数据变化下的执行与
  诊断仍可解释。

## 必须执行干净状态过渡

v3.7.0 无法读取 v3.6.0 或更早版本创建的状态。本版本没有为替换后的站点、限速、
信任与观测契约提供原地数据库迁移。

更新前先停止写入并归档完整安装：状态目录、配置、unit、二进制、外部
KEK/license/证书与审核过的声明式源文件。然后按文档执行 `uninstall --purge`，用
保留的签名更新器安装 v3.7.0，安装全新服务，按审核结果重建资源，并重新注册每一个
远程 Agent。不要把旧数据库、Agent 身份、spool 或 bundle 缓存导入 v3.7.0。

准确命令与回滚边界见[升级与迁移](upgrade-migration.md)。

## 安装后检查

1. 确认 `tiyi --version` 输出 `v3.7.0`，运行 `tiyi system health`，并确认本机节点已有
   active bundle。
2. 启用 Country Access 前先激活 Country 数据库。provider IP 订阅初始为暂停且为空；
   只对确实需要信任或执行的 feed 检查后显式 resume。
3. 在可用性负责人选择拒绝或 CRS-bypass 并于**日志 → 执行分析**验证前，WAF 过载保持
   **继续完整检查**。
4. 站点成为仅 HTTPS 后再启用 Bot 防护；测试合法浏览器、不支持的客户端、健康检查
   与必需的登录回调。
5. 按审核过的意图重建限速行与响应 profile，不要机械还原旧行。

二进制、`SHA256SUMS`、Ed25519 签名与发行清单见
[GitHub Release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.0) 与
[Gitee 镜像](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.0)。
