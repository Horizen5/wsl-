#!/bin/bash

echo "🔧 正在修复 WSL 网络和 Docker 网络代理..."

# 设置你的代理端口
PROXY_PORT=7897

# 1. 设置环境变量（可加入 shell 配置文件）
export http_proxy="http://127.0.0.1:$PROXY_PORT"
export https_proxy="http://127.0.0.1:$PROXY_PORT"
export all_proxy="socks5://127.0.0.1:$PROXY_PORT"
echo "✅ Shell 代理环境变量已设置"

# 2. 写入 shell 配置（bash/zsh）
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
else
  SHELL_RC="$HOME/.bashrc"
fi

grep -q "http_proxy" "$SHELL_RC" || cat <<EOF >> "$SHELL_RC"

# Added by fix_wsl_docker.sh
export http_proxy="http://127.0.0.1:$PROXY_PORT"
export https_proxy="http://127.0.0.1:$PROXY_PORT"
export all_proxy="socks5://127.0.0.1:$PROXY_PORT"
EOF

echo "✅ $SHELL_RC 已更新代理配置"

# 3. 设置 Docker daemon 代理
DOCKER_PROXY_CONF="/etc/systemd/system/docker.service.d/proxy.conf"
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee $DOCKER_PROXY_CONF > /dev/null <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:$PROXY_PORT"
Environment="HTTPS_PROXY=http://127.0.0.1:$PROXY_PORT"
Environment="ALL_PROXY=socks5://127.0.0.1:$PROXY_PORT"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
EOF

echo "✅ Docker systemd proxy 配置已完成"

# 4. 重启 Docker 服务
echo "🔁 重新加载并重启 Docker 服务..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart docker

# 5. 自动修复 DNS（如有必要）
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "✅ DNS 设置为 8.8.8.8"

echo "🎉 修复完成，请重新打开终端或运行：source $SHELL_RC"
