FROM coturn/coturn:latest

USER root
RUN apt-get update && apt-get install -y wget curl netcat-openbsd && rm -rf /var/lib/apt/lists/*

# CoTURN 설정
RUN echo "listening-port=3478" > /tmp/turnserver.conf
RUN echo "min-port=49152" >> /tmp/turnserver.conf
RUN echo "max-port=65535" >> /tmp/turnserver.conf
RUN echo "lt-cred-mech" >> /tmp/turnserver.conf
RUN echo "user=railway:RailwayP2P123!" >> /tmp/turnserver.conf
RUN echo "user=student:FastConnect456!" >> /tmp/turnserver.conf
RUN echo "realm=railway.webrtc" >> /tmp/turnserver.conf
RUN echo "verbose" >> /tmp/turnserver.conf
RUN echo "fingerprint" >> /tmp/turnserver.conf

# HTTP Health Check 서버 추가 (Railway Sleep 방지)
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting CoTURN + HTTP Health Server..."' >> /start.sh && \
    echo '# HTTP Health Check 서버 시작 (백그라운드)' >> /start.sh && \
    echo 'while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Length: 7\r\n\r\nHealthy" | nc -l 8080 -q 1; done &' >> /start.sh && \
    echo '# CoTURN 서버 시작 (포그라운드)' >> /start.sh && \
    echo 'exec /usr/bin/turnserver -c /tmp/turnserver.conf' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 3478 8080

CMD ["/start.sh"]
