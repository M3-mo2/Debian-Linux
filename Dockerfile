FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash coreutils findutils util-linux less nano vim \
    curl wget jq tree htop tmux git openssh-client ca-certificates \
    iputils-ping iproute2 net-tools dnsutils \
    procps psmisc lsof \
    zip unzip gzip xz-utils tar \
    python3 python3-pip nodejs npm golang-go \
    build-essential make \
    sqlite3 default-mysql-client postgresql-client \
    sed gawk grep diffutils \
    openssl \
    file sudo rsync \
    bat fd-find ripgrep fzf \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN pip3 install --no-cache-dir --break-system-packages \
    requests flask fastapi uvicorn pytest httpx rich pydantic \
    && rm -rf ~/.cache/pip

RUN npm install -g typescript nodemon pm2 eslint prettier yarn pnpm \
    && npm cache clean --force

RUN useradd -m -s /bin/bash -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /workspace
RUN mkdir -p /workspace/{projects,scripts,logs,config,data,tmp}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD bash -c 'echo "healthy" && exit 0'

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
