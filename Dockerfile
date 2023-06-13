FROM ubuntu:22.04
LABEL maintainer="avery.rozar@trolleyesecurity.com"
WORKDIR /app/
ENV TZ=Us/Eastern
ENV DEBIAN_FRONTEND=noninteractive
COPY scripts scripts/
RUN apt update && apt dist-upgrade -y && \
    apt install wget git -y && \
    wget https://static.snyk.io/cli/latest/snyk-linux -O snyk && \
    chmod +x ./snyk && \
    mv ./snyk /usr/local/bin/ && \
    useradd ccscanner --system --shell=/usr/sbin/nologin --home-dir=/app && \
    chown ccscanner:ccscanner -R /app
USER ccscanner
