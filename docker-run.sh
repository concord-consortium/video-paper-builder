#!/bin/bash

DB_CONFIG=$APP_HOME/config/database.yml
PIDFILE=$APP_HOME/tmp/pids/server.pid
AWS_CONFIG=$APP_HOME/config/aws.yml

if [ -f $PIDFILE ]; then
  rm $PIDFILE
fi

if [ ! -f $DB_CONFIG ]; then
  cp $APP_HOME/config/database.yml.docker $DB_CONFIG
fi

if [ ! -f $AWS_CONFIG ]; then
  cp $APP_HOME/config/aws.yml.docker $AWS_CONFIG
fi

bundle check || bundle install

# TODO: remove after all gem upgrades
# (this is here to ensure no old gems stick around)
bundle clean

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rake assets:precompile
fi

if [ "$RAILS_ENV" = "test" ]; then
  /etc/init.d/xvfb start
fi

if [ "$1" == "migrate-only" ]; then
  bundle exec rake db:create
  bundle exec rake db:migrate
elif [ "$1" == "rails-only" ]; then
  bundle exec rails s -b 0.0.0.0 -p 3000
else
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rails s -b 0.0.0.0 -p 3000
fi
