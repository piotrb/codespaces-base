###############################################################################
## Ruby Bootstrap
###############################################################################

# FROM ghcr.io/piotrb/codespaces-base:ruby-build as ruby

# RUN mkdir -p /tmp/bootstrap
# WORKDIR /tmp/bootstrap
# COPY .ruby-version .

# RUN RUBY_CONFIGURE_OPTS=--disable-install-doc rbenv install

# COPY Gemfile Gemfile.lock ./
# RUN bundle

###############################################################################
## Node Bootstrap
###############################################################################

# FROM ghcr.io/piotrb/codespaces-base:node-build as node

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

# FROM ghcr.io/piotrb/codespaces-base:pre-main

# USER vscode

# COPY --from=ruby /home/vscode/.rbenv /home/vscode/.rbenv
# ENV PATH=/home/vscode/.rbenv/bin:/home/vscode/.rbenv/shims:$PATH

# COPY --from=node /home/vscode/.nodenv /home/vscode/.nodenv
# ENV PATH=/home/vscode/.nodenv/bin:/home/vscode/.nodenv/shims:$PATH

# USER root
