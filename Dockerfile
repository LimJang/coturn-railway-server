FROM coturn/coturn:latest

# Railway 환경 최적화
USER root

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y wget curl && rm -rf /var/lib/apt/lists/*

# CoTURN 설정 생성
RUN echo "listening-port=\$PORT" > /etc/turnserver.conf && \
    echo "min-port=49152" >> /etc/turnserver.conf && \
    echo "max-port=65535" >> /etc/turnserver.conf && \
    echo "lt-cred-mech" >> /etc/turnserver.conf && \
    echo "user=railway:RailwayP2P123!" >> /etc/turnserver.conf && \
    echo "user=student:FastConnect456!" >> /etc/turnserver.conf && \
    echo "realm=railway.webrtc" >> /etc/turnserver.conf && \
    echo "verbose" >> /etc/turnserver.conf && \
    echo "fingerprint" >> /etc/turnserver.conf && \
    echo "log-file=stdout" >> /etc/turnserver.conf

# Railway 포트 설정
EXPOSE $PORT

# CoTURN 시작
CMD ["sh", "-c", "turnserver -c /etc/turnserver.conf --external-ip=$(wget -qO- http://ifconfig.me || echo '0.0.0.0') --listening-port=$PORT"]