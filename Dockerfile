# 使用 Emby 官方镜像
FROM emby/embyserver:latest
FROM rclone/rclone:latest AS rclone

ARG RCLONE_CONFIG_BASE64=$RCLONE_CONFIG_BASE64

USER root

# Alpine 使用 apk 而不是 apt-get
# 安装 curl, unzip, ca-certificates 和 bash (rclone 脚本需要 bash)
RUN apk update && apk add --no-cache \
    curl \
    unzip \
    ca-certificates \
    bash \
    && curl https://rclone.org/install.sh | bash \
    && rm -rf /var/cache/apk/*

# 创建启动脚本
RUN echo '#!/bin/bash\n\
if [ -n "$RCLONE_CONFIG_BASE64" ]; then\n\
    echo "正在解码 rclone 配置..."\n\
    mkdir -p /root/.config/rclone/\n\
    echo "$RCLONE_CONFIG_BASE64" | base64 -d > /root/.config/rclone/rclone.conf\n\
fi\n\
exec /init' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
