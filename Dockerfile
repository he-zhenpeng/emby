# 明确使用官方最新版作为基础镜像
FROM emby/embyserver:latest

USER root

# 使用 apk 安装必要工具并集成 rclone
RUN apk update && apk add --no-cache \
    curl \
    unzip \
    ca-certificates \
    bash \
    && curl https://rclone.org/install.sh | bash \
    && rm -rf /var/cache/apk/*

# 这里的逻辑是：启动时先解码 Rclone 配置，然后把控制权交给 Emby 原生的 /init 进程
ENTRYPOINT ["/bin/bash", "-c", "if [ -n \"$RCLONE_CONFIG_BASE64\" ]; then mkdir -p /root/.config/rclone/ && echo \"$RCLONE_CONFIG_BASE64\" | base64 -d > /root/.config/rclone/rclone.conf; fi; exec /init"]
