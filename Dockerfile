FROM debian:bookworm-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV PATH="/root/.local/bin:${PATH}"

# ============================================================
# Install all base tools and utilities
# ============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core utilities
    bash coreutils findutils util-linux less nano vim curl wget jq tree \
    htop tmux screen git openssh-client ca-certificates gnupg lsb-release \
    software-properties-common apt-transport-https sudo cron rsync \
    # Network tools
    iputils-ping iproute2 net-tools dnsutils traceroute ncat nmap telnet \
    tcpdump iperf3 mtr whois geoip-bin nload iftop socat netcat-openbsd \
    # System monitoring
    sysstat procps psmisc strace lsof pciutils usbutils htop bpytop btop \
    glances ncdu duf dust pv progress \
    # Compression tools
    zip unzip gzip bzip2 xz-utils tar p7zip-full \
    # Programming languages
    python3 python3-pip python3-venv nodejs npm golang-go ruby ruby-dev \
    default-jre-headless default-jdk-headless php-cli php-common php-mbstring \
    # Build tools
    build-essential make cmake autoconf automake pkg-config gcc g++ gdb \
    # Database clients
    sqlite3 default-mysql-client postgresql-client redis-tools \
    # Text processing
    sed awk grep diffutils patch \
    # Security tools
    openssl \
    # Media tools
    ffmpeg imagemagick \
    # Misc
    file locales rsync rclone uuid-runtime xmlstarlet pandoc poppler-utils \
    # Terminal enhancements
    bat fd-find ripgrep fzf zoxide httpie tig neofetch \
    # Web tools
    w3m lynx \
    # Performance testing
    sysbench stress stress-ng \
    # Parallel processing
    parallel moreutils \
    # Shell utilities
    bc dc units figlet cowsay cmatrix toilet \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# ============================================================
# Python packages
# ============================================================
RUN pip3 install --no-cache-dir --break-system-packages \
    requests flask django fastapi uvicorn sqlalchemy pandas numpy \
    pytest black pylint httpie rich httpx pydantic celery redis \
    boto3 Pillow cryptography paramiko ansible awscli \
    scikit-learn matplotlib seaborn jupyterlab ipython \
    && rm -rf ~/.cache/pip

# ============================================================
# Node.js global packages
# ============================================================
RUN npm install -g \
    npm@latest typescript ts-node nodemon pm2 eslint prettier yarn pnpm \
    && npm cache clean --force

# ============================================================
# Ruby gems
# ============================================================
RUN gem install bundler rails rake sinatra && gem cleanup

# ============================================================
# Install CLI tools from official sources
# ============================================================

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends gh && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

# Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
    dd of=/usr/share/keyrings/docker-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian bookworm stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | \
    dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends terraform && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

# ============================================================
# Create user and workspace
# ============================================================
RUN useradd -m -s /bin/bash -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /workspace
RUN mkdir -p /workspace/{projects,scripts,logs,config,data,backups,tmp}

# Copy scripts
COPY setup.sh /workspace/setup.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /workspace/setup.sh /entrypoint.sh

# ============================================================
# Health check and entrypoint
# ============================================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD bash -c 'echo "healthy" && exit 0'

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
