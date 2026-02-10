# 使用官方镜像
FROM emby/embyserver:latest

USER root

# 手动下载 rclone 静态二进制文件 (针对 x86_64 架构)
# 如果你的 Zeabur 环境是 ARM，请将链接中的 amd64 改为 arm
ADD https://downloads.rclone.org/v1.69.1/rclone-v1.69.1-linux-amd64.zip /tmp/rclone.zip

# 利用镜像内自带的 busybox 或基础 shell 进行解压
RUN cd /tmp && \
    unzip rclone.zip && \
    cp /tmp/rclone-*-linux-amd64/rclone /usr/bin/rclone && \
    chmod +x /usr/bin/rclone && \
    rm -rf /tmp/*

# 启动逻辑
ENTRYPOINT ["/bin/sh", "-c", "if [ -n \"$RCLONE_CONFIG_BASE64\" ]; then mkdir -p /root/.config/rclone/ && echo \"$RCLONE_CONFIG_BASE64\" | base64 -d > /root/.config/rclone/rclone.conf; fi; exec /init"]
