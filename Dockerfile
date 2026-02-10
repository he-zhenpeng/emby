# 使用 Emby 官方镜像作为基础
FROM emby/embyserver:latest

# 切换到 root 用户以安装工具
USER root

# 安装 curl 和 rclone
# Emby 官方镜像基于 Ubuntu，所以使用 apt-get
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    ca-certificates \
    && curl https://rclone.org/install.sh | bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
