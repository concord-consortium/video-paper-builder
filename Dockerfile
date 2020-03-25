FROM ruby:2.3.0
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN apt-get update -qq && apt-get install -y --force-yes build-essential vim-tiny xvfb libgtk-3-0 libdbus-glib-1-2 libxt6 libasound2 && apt-get clean && rm -rf /var/lib/apt/lists/*

# add versioned firefox (for selenium 2.31.0)
ARG FIREFOX_VERSION=19.0.2
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

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
