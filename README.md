# WSL & Docker 网络检测与自动修复工具

该项目包含两个工具脚本：

* 【wsl\_docker\_check.sh】WSL & Docker 网络系统综合检测
* 【wsl\_docker\_fix.sh】根据检测结果自动修复常见问题

---

## 一、工具使用

### 1. 先下载项目

```bash
git clone https://github.com/Horizen5/wsl-network.git
cd wsl-network
```

### 2. 运行网络检测脚本

```bash
chmod +x wsl_docker_check.sh
./wsl_docker_check.sh
```

### 3. 根据结果进行修复

```bash
chmod +x wsl_docker_fix.sh
sudo ./wsl_docker_fix.sh
```

---

## 二、wsl\_docker\_check.sh

该脚本检查内容包括：

* WSL 网络 IP & 默认网关
* ping 测试 (8.8.8.8 / google.com)
* curl 测试 https
* Docker 状态 & 镜像拉取
* Docker 内容器网络连接
* Docker 代理配置 proxy.conf
* /etc/docker/daemon.json DNS 配置
* Clash 本地端口监听 (7890/7897)

---

## 三、wsl\_docker\_fix.sh

支持一键修复下列常见问题：

* 修复 /etc/resolv.conf DNS 配置
* 修复 /etc/docker/daemon.json DNS 配置
* 检测并调整 Docker 代理 proxy.conf
* 重启 docker.service 和 networking
* 检测是否 Clash 本地正确启动

使用时需 root 权限：

```bash
sudo ./wsl_docker_fix.sh
```

---

## 四、集成自动检测

如需每次打开终端自动检测，可集成到 `.bashrc`：

```bash
echo "bash ~/wsl-network/wsl_docker_check.sh" >> ~/.bashrc
```

---

## 五、故障处理提示

* 如果 Docker 内 ping IP 正常、DNS ping 失败，应为 DNS 配置错误
* 如果 Clash 未启动，且 Docker 代理指向为 127.0.0.1:7897，则会断网
* 如需系统级修复，请使用系统管理员权限

---

欢迎提 issue / PR 优化脚本功能。
