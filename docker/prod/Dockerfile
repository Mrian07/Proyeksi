FROM ruby:2.7.5-buster
MAINTAINER operations@proyeksiapp.com

# Allow platform-specific additions. Valid values are: on-prem,saas,bahn
ARG PLATFORM=on-prem
# Use OAuth token in case private gems need to be fetched
ARG GITHUB_OAUTH_TOKEN
ARG DEBIAN_FRONTEND=noninteractive

ENV NODE_VERSION="14.17.0"
ENV BUNDLER_VERSION="2.1.4"
ENV BUNDLE_PATH__SYSTEM=false
ENV APP_USER=app
ENV APP_PATH=/app
ENV APP_DATA_PATH=/var/proyeksiapp/assets
ENV PGDATA=/var/proyeksiapp/pgdata
ENV PGVERSION="13"
ENV PGBIN="/usr/lib/postgresql/$PGVERSION/bin"

ENV DATABASE_URL=postgres://proyeksiapp:proyeksiapp@127.0.0.1/proyeksiapp
ENV RAILS_ENV=production
ENV RAILS_CACHE_STORE=memcache
ENV RAILS_GROUPS=production
ENV RAILS_LOG_TO_STDOUT=1
ENV RAILS_SERVE_STATIC_FILES=1
ENV PROYEKSIAPP_INSTALLATION__TYPE=docker
# Valid values are: standard,bim
ENV PROYEKSIAPP_EDITION=standard
ENV NEW_RELIC_AGENT_ENABLED=false
ENV ATTACHMENTS_STORAGE_PATH=$APP_DATA_PATH/files
# Set a default key base, ensure to provide a secure value in production environments!
ENV SECRET_KEY_BASE=OVERWRITE_ME

WORKDIR $APP_PATH

COPY docker/prod/setup ./docker/prod/setup
RUN ./docker/prod/setup/preinstall.sh

COPY Gemfile ./Gemfile
COPY Gemfile.* ./
COPY modules ./modules
COPY vendor ./vendor
# some gemspec files of plugins require files in there, notably ProyeksiApp::Version
COPY lib ./lib

RUN bundle install --quiet --deployment --path vendor/bundle --no-cache \
  --with="$RAILS_GROUPS" --without="test development" --jobs=8 --retry=3 && \
  rm -rf vendor/bundle/ruby/*/cache && rm -rf vendor/bundle/ruby/*/gems/*/spec && rm -rf vendor/bundle/ruby/*/gems/*/test

# Finally, copy over the whole thing
COPY . .

RUN ./docker/prod/setup/postinstall.sh

# Expose ports for apache and postgres
EXPOSE 80 5432

# Expose the postgres data directory and ProyeksiApp data directory as volumes
VOLUME ["$PGDATA", "$APP_DATA_PATH"]

# Set a custom entrypoint to allow for privilege dropping and one-off commands
ENTRYPOINT ["./docker/prod/entrypoint.sh"]

# Set default command to launch the all-in-one configuration supervised by supervisord
CMD ["./docker/prod/supervisord"]
