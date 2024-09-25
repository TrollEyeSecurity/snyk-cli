FROM ubuntu:22.04
LABEL maintainer="avery.rozar@trolleyesecurity.com"
WORKDIR /app/
ENV TZ=Us/Eastern
ENV DEBIAN_FRONTEND=noninteractive
COPY scripts scripts/
RUN apt update && apt dist-upgrade -y && \
    apt install wget git python3 python3-pip make dotnet-sdk-7.0 nodejs npm yarnpkg pipenv ruby ruby-dev maven gradle libpq-dev file -y && \
    gem install bundler && \
    wget https://go.dev/dl/go1.23.1.linux-"$(dpkg --print-architecture)".tar.gz  && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.1.linux-"$(dpkg --print-architecture)".tar.gz && \
    rm -rf go1.23.1.linux-"$(dpkg --print-architecture)".tar.gz && \
    useradd ccscanner --system --shell=/usr/sbin/nologin --home-dir=/app && \
    chown ccscanner:ccscanner -R /app
RUN if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        wget https://static.snyk.io/cli/latest/snyk-linux-arm64 -O snyk \
    elif [ "$(dpkg --print-architecture)" = "arm64" ]; then \
        wget https://static.snyk.io/cli/latest/snyk-linux -O snyk; \
    else \
        echo "Unsupported architecture"; \
        exit 1; \
    fi && \
    chmod +x ./snyk && mv ./snyk /usr/local/bin/
USER ccscanner
