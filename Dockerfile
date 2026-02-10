# 使用 Emby 官方镜像
FROM emby/embyserver:latest
FROM rclone/rclone:latest AS rclone

ARG RCLONE_CONFIG_BASE64=$RCLONE_CONFIG_BASE64

USER root



# 直接在 ENTRYPOINT 里写逻辑，不再调用外部 /entrypoint.sh 文件
ENTRYPOINT ["/bin/bash", "-c", "if [ -n \"$RCLONE_CONFIG_BASE64\" ]; then mkdir -p /root/.config/rclone/ && echo \"$RCLONE_CONFIG_BASE64\" | base64 -d > /root/.config/rclone/rclone.conf && echo 'Rclone config restored.'; fi; exec /init"]
