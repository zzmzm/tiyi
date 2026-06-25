# Tiyi 快速开始

Tiyi 是一个单可执行文件、可自托管、内置 WAF 的反向代理，并集成了管理平面。

## 1. 安装

```sh
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash
```

安装脚本会自动识别平台（Linux amd64/arm64），解析最新的已签名发行版，完成校验后
将 `tiyi` 安装到 `/usr/local/bin`。

指定版本或更改安装目录：

```sh
TIYI_VERSION=v3.0.0 TIYI_PREFIX="$HOME/.local/bin" \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh)"
```

## 2. 手动校验下载（可选）

每个发行版都附带 `SHA256SUMS`、`SHA256SUMS.sig` 以及对应平台的压缩包。先校验
SHA-256：

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

如需使用 OpenSSL 3.x 校验校验和文件的 Ed25519 签名，请先用已发布的原始公钥
（`release-key.pub`）构建 PEM：

```sh
{ printf '302a300506032b6570032100'; base64 -d release-key.pub | xxd -p -c 256; } \
  | xxd -r -p | base64 > /tmp/k.b64
{ echo "-----BEGIN PUBLIC KEY-----"; cat /tmp/k.b64; echo "-----END PUBLIC KEY-----"; } \
  > release-key.pem

openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
  -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

其中 `302a300506032b6570032100` 是固定的 Ed25519 SubjectPublicKeyInfo 头部；
已发布的公钥即 32 字节原始公钥的 base64 形式。

## 3. 运行

单机安装会在一个进程中同时运行服务端、agent 和仪表盘：

```sh
tiyi standalone
```

打开仪表盘，完成首次管理员初始化，并添加第一个站点。完整的运维流程（配置文件、
管理套接字、站点、上游、证书、WAF 策略）请参阅产品内文档。

## 4. 保持更新

```sh
tiyi self-update --check     # 是否有更新的已签名发行版？
tiyi self-update --yes       # 下载、校验并安装
```

`self-update` 会在替换磁盘上的二进制之前，针对内嵌于二进制中的发布公钥校验
SHA-256 与 Ed25519 签名。更新后请**重启服务**。使用 `--channel prerelease`
可跟踪预发布版本。

## 5. 授权

Tiyi 在单节点 Community 模式下可免费运行。多节点（远程 agent）集群需要授权许可，
详见 [EULA.md](../../EULA.md)。

## 支持

安全问题请按照 [SECURITY.md](../../SECURITY.md) 私下报告；其他问题请在分发仓库
提交 issue。
