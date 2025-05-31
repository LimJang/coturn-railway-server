FROM coturn/coturn:latest

# Root 권한 설정
USER root

# 필수 패키지 설치
RUN apt-get update && apt-get install -y wget curl && rm -rf /var/lib/apt/lists/*

# CoTURN 설정 파일 생성 (문법 오류 수정)
RUN echo "listening-port=3478" > /tmp/turnserver.conf
RUN echo "min-port=49152" >> /tmp/turnserver.conf
RUN echo "max-port=65535" >> /tmp/turnserver.conf
RUN echo "lt-cred-mech" >> /tmp/turnserver.conf
RUN echo "user=railway:RailwayP2P123!" >> /tmp/turnserver.conf
RUN echo "user=student:FastConnect456!" >> /tmp/turnserver.conf
RUN echo "realm=railway.webrtc" >> /tmp/turnserver.conf
RUN echo "verbose" >> /tmp/turnserver.conf
RUN echo "fingerprint" >> /tmp/turnserver.conf
RUN echo "log-file=stdout" >> /tmp/turnserver.conf

# 포트 노출
EXPOSE 3478

# CoTURN 서버 시작 (간단한 명령어)
CMD ["/usr/bin/turnserver", "-c", "/tmp/turnserver.conf", "--external-ip=0.0.0.0"]
