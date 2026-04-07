FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Apply OS security updates at build time. The date-based image tag
# serves as the version pin -- old tags are never deleted, so any
# prior patch level can be recovered by pulling the appropriate tag.
# Full apt package pinning is not implemented; see gold-image-spec.md.
RUN apt-get update -qq && apt-get upgrade -y -qq

# System packages (not version-pinned -- see gold-image-spec.md for details)
# TODO: pin apt packages to specific versions for full reproducibility
RUN apt-get update -qq && apt-get install -y -qq \
    vim neovim openssh-client \
    curl wget git jq make python3-pip \
    build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libffi-dev liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# goenv
RUN git clone https://github.com/go-nv/goenv.git /usr/local/goenv
ENV GOENV_ROOT="/usr/local/goenv"
ENV PATH="$GOENV_ROOT/bin:$GOENV_ROOT/shims:$PATH"

# Go versions -- add new versions here, never remove old ones
RUN goenv install 1.24.13
RUN goenv global 1.24.13

# pyenv
RUN git clone https://github.com/pyenv/pyenv.git /usr/local/pyenv
ENV PYENV_ROOT="/usr/local/pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Python versions -- add new versions here, never remove old ones
RUN pyenv install 3.12
RUN pyenv global 3.12

# PATH setup for login shells
RUN echo 'export GOENV_ROOT="/usr/local/goenv"' > /etc/profile.d/goenv.sh && \
    echo 'export PATH="$GOENV_ROOT/bin:$GOENV_ROOT/shims:$PATH"' >> /etc/profile.d/goenv.sh
RUN echo 'export PYENV_ROOT="/usr/local/pyenv"' > /etc/profile.d/pyenv.sh && \
    echo 'export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"' >> /etc/profile.d/pyenv.sh
