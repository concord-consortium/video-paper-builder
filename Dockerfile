FROM ruby:2.3.0
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN apt-get update -qq && apt-get install -y --force-yes build-essential vim-tiny xvfb libgtk-3-0 libdbus-glib-1-2 libxt6 libasound2 && apt-get clean && rm -rf /var/lib/apt/lists/*

#Install Google Chrome for Selenium
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
  && apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y google-chrome-stable

# update to latest bundler
RUN gem install bundler -v '~>1'

ENV APP_HOME /vpb
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# use a mounted volume so the gems don't need to be rebundled each time
ENV BUNDLE_GEMFILE $APP_HOME/Gemfile
ENV BUNDLE_JOBS 2
ENV BUNDLE_PATH /bundle
ENV RAILS_ENV development

# set xvfb display
ENV DISPLAY :99.0

EXPOSE 3000
