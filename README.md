# WSL + Docker 网络修复工具说明文档

本项目提供一个增强版自动修复脚本，用于诊断并修复 WSL (Windows Subsystem for Linux) 与 Docker 网络连接异常问题。

---

## ✨ 功能特性

* ✅ 自动检测并配置 WSL 环境下的代理环境变量
* ✅ 修复 Docker 无法联网、拉取镜像失败等问题
* ✅ 设置 systemd 中 Docker 的代理配置（支持 Clash/Socks5）
* ✅ 自动重载 systemd 并重启 Docker 服务
* ✅ 设置 DNS 避免解析失败
* ✅ 可选集成为 shell 命令（`.bashrc` / `.zshrc`）

---

## 使用方法

### 1. 下载并执行脚本

```bash
wget -O fix_wsl_docker.sh https://raw.githubusercontent.com/<yourname>/<repo>/main/fix_wsl_docker.sh
chmod +x fix_wsl_docker.sh
./fix_wsl_docker.sh
```

### 2. 自动集成到 shell (可选)

脚本会将代理变量自动追加到你的 `~/.bashrc` 或 `~/.zshrc` 中：

```bash
export http_proxy="http://127.0.0.1:7897"
export https_proxy="http://127.0.0.1:7897"
export all_proxy="socks5://127.0.0.1:7897"
```

重新加载配置文件以立即生效：

```bash
source ~/.bashrc   # 或 source ~/.zshrc
```

---

## ⚖️ 脚本内容概览

```bash
#!/bin/bash

PROXY_PORT=7897

# 设置 shell 代理环境变量
export http_proxy="http://127.0.0.1:$PROXY_PORT"
export https_proxy="http://127.0.0.1:$PROXY_PORT"
export all_proxy="socks5://127.0.0.1:$PROXY_PORT"

# 写入到 shell 配置文件
...

# 配置 Docker 代理
sudo tee /etc/systemd/system/docker.service.d/proxy.conf > /dev/null <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:$PROXY_PORT"
Environment="HTTPS_PROXY=http://127.0.0.1:$PROXY_PORT"
Environment="ALL_PROXY=socks5://127.0.0.1:$PROXY_PORT"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
EOF

# 重启 Docker
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart docker

# 修复 DNS
sudo bash -c 'echo nameserver 8.8.8.8 > /etc/resolv.conf'
```

---

## 工具效果验证

```bash
docker run --rm alpine ping -c 3 google.com
```

> 如有返回 100% packet loss，请确保 clash/sing-box 正常运行并打开 7897 端口。

```bash
docker run --rm alpine ping -c 3 8.8.8.8
```

> 如能 ping 通 IP 而不能进行域名解析，请确保 `/etc/resolv.conf` DNS 设置正确

---

## ✨ 本项目未来计划

* [ ] 支持 Clash Meta/Sing-box 自动检测
* [ ] 支持 WSL DNS Stub Listener 自动关闭
* [ ] 支持 GUI/命令行弹窗工具

---

## ✉️ 联系我

若你有任何问题或建议，欢迎 PR / Issue 或进一步联系我。

---

感谢使用！如有必要，我可以为你为此脚本生成 GitHub Repo 或 Gist 链接。
