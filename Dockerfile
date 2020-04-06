FROM ruby:2.6.6
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN apt-get update -qq && apt-get install -qq -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*

# update to latest bundler
RUN gem install bundler -v '~>1'

# install foreman to handle requests
RUN gem install foreman

ENV APP_HOME /vpb
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE $APP_HOME/Gemfile

# need to copy the Gemfile.lock created during build so it isn't overriden by the following add
RUN bundle install --without development test && \
    cp Gemfile.lock Gemfile.lock-docker
ADD . $APP_HOME

# get files into the right place
RUN mv -f Gemfile.lock-docker Gemfile.lock && \
    cp config/database.docker.yml config/database.yml && \
    cp config/aws.docker.yml config/aws.yml

## Configured nginx (after bundler so we don't have to wait for bundler to change config)
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Add default nginx config
ADD docker/prod/nginx-sites.conf /etc/nginx/sites-enabled/default

# forward nginx request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# set to production
ENV RAILS_ENV production

# compile the assets, need a fake secret_key_base otherwise the devise initializer fails
RUN SECRET_KEY_BASE=fake bundle exec rake assets:precompile

EXPOSE 80

CMD ./docker/prod/prod-run.sh

