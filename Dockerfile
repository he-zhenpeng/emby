FROM emby/embyserver:latest

USER root
# 安装基础工具
RUN apt-get update && apt-get install -y curl unzip ca-certificates \
    && curl https://rclone.org/install.sh | bash

# 创建配置目录
RUN mkdir -p /root/.config/rclone/

# 创建启动脚本
RUN echo '#!/bin/bash\n\
if [ -n "$RCLONE_CONFIG_BASE64" ]; then\n\
    echo "Decoding rclone config..."\n\
    echo "$RCLONE_CONFIG_BASE64" | base64 -d > /root/.config/rclone/rclone.conf\n\
fi\n\
exec /init' > /entrypoint.sh

RUN chmod +x /entrypoint.sh

# 使用自定义脚本启动
ENTRYPOINT ["/entrypoint.sh"]
