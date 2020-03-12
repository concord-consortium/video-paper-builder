FROM ruby:1.9.3
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN apt-get update -qq && apt-get install -y --force-yes build-essential

ENV APP_HOME /vpb
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# use a mounted volume so the gems don't need to be rebundled each time
ENV BUNDLE_GEMFILE $APP_HOME/Gemfile
ENV BUNDLE_JOBS 2
ENV BUNDLE_PATH /bundle
ENV RAILS_ENV development

EXPOSE 3000
