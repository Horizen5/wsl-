#!/bin/bash

echo "========== [1] WSL 网络配置 =========="
ip addr show eth0 | grep inet
echo -e "\n默认网关："
ip route | grep default

echo -e "\n✅ 测试 WSL 网络连通性："
ping -c 3 8.8.8.8
ping -c 3 google.com
curl -s -I https://google.com | head -n 1

echo -e "\n========== [2] Docker 服务状态 =========="
systemctl is-active --quiet docker && echo "✅ Docker 正在运行" || echo "❌ Docker 未启动"

echo -e "\n========== [3] Docker 镜像拉取测试 =========="
docker pull --quiet alpine && echo "✅ 成功拉取 alpine 镜像" || echo "❌ 拉取失败"

echo -e "\n========== [4] Docker 网络测试 =========="
echo -e "\n🔸 ping 8.8.8.8（直接 IP）"
docker run --rm alpine ping -c 3 8.8.8.8

echo -e "\n🔸 ping google.com（DNS 解析）"
docker run --rm alpine ping -c 3 google.com

echo -e "\n🔸 curl https 测试"
docker run --rm alpine sh -c "apk add --no-cache curl >/dev/null && curl -s -I https://google.com | head -n 1"

echo -e "\n========== [5] Docker 守护进程代理配置 =========="
PROXY_FILE="/etc/systemd/system/docker.service.d/proxy.conf"
if [ -f "$PROXY_FILE" ]; then
  cat "$PROXY_FILE"
else
  echo "⚠️ 未配置 proxy.conf"
fi

echo -e "\n========== [6] Docker DNS 设置 =========="
[ -f /etc/docker/daemon.json ] && cat /etc/docker/daemon.json || echo "⚠️ 未设置 /etc/docker/daemon.json"

echo -e "\n========== [7] Clash 本地端口监听检查 =========="
ss -tunlp | grep -E '789[0-9]' || echo "⚠️ Clash 未监听常见端口（如 7890/7897）"

echo -e "\n========== 检查完成 =========="
