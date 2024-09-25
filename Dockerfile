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
RUN echo "checking architecture"; \
    [[ "$(dpkg --print-architecture)" == "arm64" ]] && wget https://static.snyk.io/cli/latest/snyk-linux-"$(dpkg --print-architecture)" -O snyk && \
    [[ "$(dpkg --print-architecture)" == "amd64" ]] &&  wget https://static.snyk.io/cli/latest/snyk-linux -O snyk && \
    chmod +x ./snyk && \
    mv ./snyk /usr/local/bin/
USER ccscanner
