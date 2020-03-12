#!/bin/bash

# This script is intended to be run inside of a development Docker container, NOT for production!

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
