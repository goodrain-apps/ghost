FROM ghost:0.8

# Timezone
RUN echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata \
    && groupadd  -g 200 rain \
    && useradd -u 200 -g 200 rain
COPY config.js /tmp/
COPY entrypoint.sh /

EXPOSE 2368
VOLUME /data