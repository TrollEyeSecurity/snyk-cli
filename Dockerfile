FROM ubuntu:22.04
LABEL maintainer="avery.rozar@trolleyesecurity.com"
WORKDIR /app/
ENV TZ=Us/Eastern
ENV DEBIAN_FRONTEND=noninteractive
COPY scripts scripts/
RUN apt update && apt dist-upgrade -y && \
    apt install wget git python3 python3-pip make dotnet-sdk-7.0 nodejs npm -y && \
    wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz  && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    wget https://static.snyk.io/cli/latest/snyk-linux -O snyk && \
    chmod +x ./snyk && \
    mv ./snyk /usr/local/bin/ && \
    useradd ccscanner --system --shell=/usr/sbin/nologin --home-dir=/app && \
    chown ccscanner:ccscanner -R /app
USER ccscanner
