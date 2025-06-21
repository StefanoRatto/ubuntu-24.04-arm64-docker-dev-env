# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=20.x
ENV GOPATH=/home/dev/go
ENV PATH="/home/dev/go/bin:$PATH"

# Update package list and install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    openssh-server \
    openssh-client \
    sudo \
    nano \
    vim \
    neovim \
    htop \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget https://go.dev/dl/go1.22.4.linux-arm64.tar.gz \
    && tar -C /usr/local -xzf go1.22.4.linux-arm64.tar.gz \
    && rm go1.22.4.linux-arm64.tar.gz

# Add Go to PATH
ENV PATH="/usr/local/go/bin:$PATH"

# Install PHP and common extensions
RUN apt-get update && apt-get install -y \
    php8.3 \
    php8.3-cli \
    php8.3-fpm \
    php8.3-common \
    php8.3-mysql \
    php8.3-zip \
    php8.3-gd \
    php8.3-mbstring \
    php8.3-curl \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-opcache \
    php8.3-intl \
    composer \
    && rm -rf /var/lib/apt/lists/*

# Install C/C++ development tools
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    gdb \
    clang \
    clang-tidy \
    clang-format \
    make \
    cmake \
    pkg-config \
    valgrind \
    cppcheck \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get install -y nodejs

# Install TypeScript globally
RUN npm install -g typescript

# Install Next.js globally
RUN npm install -g next

# Install React development tools
RUN npm install -g create-react-app

# Install SQLite
RUN apt-get update && apt-get install -y \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a development user 'dev' with password 'dev'
RUN useradd -m -s /bin/bash dev \
    && echo "dev:dev" | chpasswd \
    && usermod -aG sudo dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure SSH
RUN mkdir -p /var/run/sshd \
    && mkdir -p /home/dev/.ssh \
    && chown dev:dev /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# Add the dev-local public key to authorized_keys
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7CC0RMNOT8gDA/GdcERBCnwcl8A3/G3kwBjVn/hCKbwaqsclxRQCpQW9RTrDk3IhYazJ6sQkT/ODO9ZYh35jLf8vUGYDubyEQxIYYBHp5DoHCQ1JvdeHDYPCflGSbTvzUePOI5nLC6c4GVWEIwpH/gfeUk9i+AgxTj6Oo+WlT9EA+szlaeI70KYg0UX3CQs2s1EiO95MIGA6bCiQ9SuX7vi0YPF0Y/SKnz0pXnisaNmueO61ZAR6/S7LPeIuptQ2ePOe92FVH0jPLBohTZ5x4c6jwgxzo0YBFE0zcP0C8qhHWatMx0JcNI9fgFoTfRKSjaCogSgTd3qE0foi7l/dj raste@rso2" > /home/dev/.ssh/authorized_keys \
    && chown dev:dev /home/dev/.ssh/authorized_keys \
    && chmod 600 /home/dev/.ssh/authorized_keys

# Configure SSH for key-based authentication
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
    && echo "AllowUsers dev" >> /etc/ssh/sshd_config \
    && echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config

# Create comprehensive home directory structure for dev user
RUN mkdir -p /home/dev/dev \
    && mkdir -p /home/dev/dev/databases \
    && mkdir -p /home/dev/dev/projects \
    && mkdir -p /home/dev/dev/workspace \
    && mkdir -p /home/dev/go \
    && mkdir -p /home/dev/go/src \
    && mkdir -p /home/dev/go/bin \
    && mkdir -p /home/dev/go/pkg \
    && mkdir -p /home/dev/.npm \
    && mkdir -p /home/dev/.npm-global \
    && mkdir -p /home/dev/.cache/yarn \
    && mkdir -p /home/dev/.config/nvim \
    && mkdir -p /home/dev/.vim \
    && mkdir -p /home/dev/.node_modules_cache \
    && mkdir -p /home/dev/.cache \
    && mkdir -p /home/dev/.local/share \
    && mkdir -p /home/dev/.local/bin \
    && mkdir -p /home/dev/Documents \
    && mkdir -p /home/dev/Downloads \
    && mkdir -p /home/dev/Pictures \
    && mkdir -p /home/dev/Music \
    && mkdir -p /home/dev/Videos \
    && chown -R dev:dev /home/dev

# Switch to dev user
USER dev
WORKDIR /home/dev

# Configure npm to use user directory for global packages
RUN npm config set prefix '/home/dev/.npm-global' \
    && npm config set cache '/home/dev/.npm'

# Add npm global bin to PATH
ENV PATH="/home/dev/.npm-global/bin:$PATH"

# Install additional Node.js tools
RUN npm install -g \
    @types/node \
    nodemon \
    eslint \
    prettier \
    yarn

# Install Python packages
RUN pip3 install --user --break-system-packages \
    ipython \
    jupyter \
    pytest \
    black \
    flake8 \
    mypy \
    requests \
    numpy \
    pandas \
    matplotlib \
    scipy

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install github.com/fatih/gomodifytags@latest \
    && go install github.com/josharian/impl@latest \
    && go install github.com/cweill/gotests/gotests@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Configure Go PATH for SSH sessions
RUN echo 'export PATH=/usr/local/go/bin:/home/dev/go/bin:$PATH' >> /home/dev/.bashrc \
    && echo 'export PATH=/usr/local/go/bin:/home/dev/go/bin:$PATH' >> /home/dev/.profile \
    && echo 'export GOPATH=/home/dev/go' >> /home/dev/.bashrc \
    && echo 'export GOPATH=/home/dev/go' >> /home/dev/.profile

# Configure git (will be overridden by volume mount if exists)
RUN git config --global init.defaultBranch main \
    && git config --global user.name "Dev User" \
    && git config --global user.email "dev@localhost"

# Create a sample project structure
RUN mkdir -p /home/dev/dev/projects

# Switch back to root for final setup
USER root

# Expose ports
EXPOSE 22 80 3000 8000 8080

# Create startup script that fixes permissions for mounted authorized_keys
RUN echo '#!/bin/bash\n\
# Fix permissions for mounted authorized_keys file\n\
if [ -f /home/dev/.ssh/authorized_keys ]; then\n\
    chown dev:dev /home/dev/.ssh/authorized_keys\n\
    chmod 600 /home/dev/.ssh/authorized_keys\n\
fi\n\
# Ensure proper ownership of home directory\n\
chown -R dev:dev /home/dev\n\
service ssh start\n\
tail -f /dev/null' > /start.sh \
    && chmod +x /start.sh

# Set the default command
CMD ["/start.sh"] 