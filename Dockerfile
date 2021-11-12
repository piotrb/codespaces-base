FROM mcr.microsoft.com/vscode/devcontainers/base:focal as base

# Build Deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  bison \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libdb-dev \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  ruby \
  direnv \
  nodejs \
  neovim \
  tmux \
  tig \
  && rm -rf /var/lib/apt/lists/*

# App Deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  postgresql-client-12 \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

###############################################################################
## Ruby Build Stage
###############################################################################

FROM base as ruby-build

USER vscode

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
  cd ~/.rbenv && src/configure && make -C src && \
  mkdir -p ~/.rbenv/plugins && \
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

ENV PATH=/home/vscode/.rbenv/bin:/home/vscode/.rbenv/shims:$PATH

###############################################################################
## Node Build Stage
###############################################################################

FROM base as node-build

USER vscode

RUN git clone https://github.com/nodenv/nodenv.git ~/.nodenv && \
  cd ~/.nodenv && src/configure && make -C src && \
  mkdir -p ~/.nodenv/plugins && \
  git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build && \
  git clone https://github.com/nodenv/node-build-update-defs.git ~/.nodenv/plugins/node-build-update-defs && \
  git clone https://github.com/nodenv/nodenv-package-rehash.git  ~/.nodenv/plugins/nodenv-package-rehash

ENV PATH=/home/vscode/.nodenv/bin:/home/vscode/.nodenv/shims:$PATH

###############################################################################
## Pre Main Stage
###############################################################################

FROM base as pre-main

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

# Install Starship globally
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# Install Overmind globally
ARG OVERMIND_VERSION=2.2.2
RUN curl -L -o /tmp/overmind.gz https://github.com/DarthSim/overmind/releases/download/v${OVERMIND_VERSION}/overmind-v${OVERMIND_VERSION}-linux-amd64.gz && \
  gunzip /tmp/overmind.gz && \
  chmod +x /tmp/overmind && \
  mv /tmp/overmind /usr/local/bin/

# Install Library Script Stuff
COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts/

## Install Docker
ENV DOCKER_BUILDKIT=1

RUN apt-get update \
  && bash /tmp/library-scripts/docker-debian.sh \
  && rm -rf /var/lib/apt/lists/*

###############################################################################
## Ruby Bootstrap
###############################################################################

# FROM ruby-build as ruby

# RUN mkdir -p /tmp/bootstrap
# WORKDIR /tmp/bootstrap
# COPY .ruby-version .

# RUN RUBY_CONFIGURE_OPTS=--disable-install-doc rbenv install

# COPY Gemfile Gemfile.lock ./
# RUN bundle

###############################################################################
## Node Bootstrap
###############################################################################

# FROM node-build as node

# RUN mkdir -p /tmp/bootstrap
# WORKDIR /tmp/bootstrap
# COPY .node-version ./

# RUN nodenv update-version-defs
# RUN nodenv install

# RUN npm install --global yarn

# COPY package.json yarn.lock ./
# COPY .yarnrc.yml ./
# RUN mkdir -p .yarn
# COPY .yarn/plugins .yarn/plugins/
# COPY .yarn/releases .yarn/releases/
# # RUN ls -al .yarn
# # RUN find .yarn
# # RUN mkdir -p .yarn/cache

# RUN yarn

###############################################################################
## Main Stage
###############################################################################

# FROM pre-main

# USER vscode

# COPY --from=ruby /home/vscode/.rbenv /home/vscode/.rbenv
# ENV PATH=/home/vscode/.rbenv/bin:/home/vscode/.rbenv/shims:$PATH

# COPY --from=node /home/vscode/.nodenv /home/vscode/.nodenv
# ENV PATH=/home/vscode/.nodenv/bin:/home/vscode/.nodenv/shims:$PATH

# USER root
