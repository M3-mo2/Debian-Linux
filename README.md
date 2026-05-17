# Debian Development Environment for Railway

A comprehensive Debian-based development environment optimized for Railway deployment with all essential tools pre-installed.

## Features

### Programming Languages
- **Python 3** - with pip, venv, and popular packages (Flask, Django, FastAPI, Pandas, NumPy, etc.)
- **Node.js** - with npm, yarn, pnpm, TypeScript, and common tools
- **Go** - Golang compiler and tools
- **Ruby** - with bundler, Rails, Sinatra
- **Java** - OpenJDK (headless)
- **PHP** - CLI with common extensions

### Development Tools
- **Git** - version control
- **GitHub CLI (gh)** - GitHub from terminal
- **Docker CLI** - container management
- **kubectl** - Kubernetes management
- **Helm** - Kubernetes package manager
- **Terraform** - infrastructure as code

### System Utilities
- **htop, bpytop, btop, glances** - system monitoring
- **tmux, screen** - terminal multiplexers
- **vim, nano** - text editors
- **tree, ncdu, duf, dust** - file/disk visualization
- **bat, fd-find, ripgrep, fzf** - modern CLI replacements
- **jq, yq** - JSON/YAML processing
- **curl, wget, httpie** - HTTP clients

### Network Tools
- **nmap, tcpdump, iperf3** - network analysis
- **dig, nslookup, whois** - DNS and domain tools
- **mtr, traceroute** - network diagnostics
- **nload, iftop, nethogs** - bandwidth monitoring

### Build & Compilation
- **build-essential** - gcc, g++, make
- **cmake, autoconf, automake** - build systems
- **pkg-config** - library configuration

### Database Clients
- **sqlite3** - SQLite
- **mysql-client** - MySQL/MariaDB
- **postgresql-client** - PostgreSQL
- **redis-tools** - Redis

### Compression
- **zip, unzip, gzip, bzip2, xz-utils, tar, p7zip-full**

### Media
- **ffmpeg** - video/audio processing
- **imagemagick** - image manipulation

## Quick Start

### Deploy to Railway

1. Push this repository to GitHub
2. Connect your GitHub account to Railway
3. Create a new project from your repository
4. Railway will automatically detect the Dockerfile and build

### Local Development

```bash
# Build the image
docker build -t debian-dev-env .

# Run the container
docker run -it --name dev-env debian-dev-env

# Run with volume mount for persistent work
docker run -it -v $(pwd)/workspace:/workspace debian-dev-env
```

## Workspace Structure

```
/workspace/
├── projects/    # Your development projects
├── scripts/     # Custom scripts
├── logs/        # Log files
├── config/      # Configuration files
├── data/        # Data files
├── backups/     # Backup files
└── tmp/         # Temporary files
```

## Configuration

### Railway Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TZ` | Timezone | `UTC` |
| `PORT` | Port for services | `3000` |

### Custom Setup

To add additional tools or configurations, modify the `setup.sh` script or extend the `Dockerfile`.

## Python Packages Pre-installed

- requests, flask, django, fastapi, uvicorn
- sqlalchemy, pandas, numpy, scikit-learn
- matplotlib, seaborn, jupyterlab, ipython
- pytest, black, pylint
- boto3, Pillow, cryptography, paramiko
- ansible, awscli, celery, redis

## Node.js Packages Pre-installed

- typescript, ts-node, nodemon
- pm2, eslint, prettier
- yarn, pnpm

## Ruby Gems Pre-installed

- bundler, rails, rake, sinatra

## Security Notes

- Container runs as `developer` user with sudo access
- No secrets or credentials are included
- Use Railway environment variables for sensitive data
- SSH client is available but no server is running by default

## License

MIT
