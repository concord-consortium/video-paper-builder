source "http://rubygems.org"
ruby "2.6.6"

gem "rails", "~> 6"
gem "jquery-rails"
gem "jquery-ui-rails"

gem "aws-sdk-s3"
gem "aws-sdk-elastictranscoder"
gem "aws-ses", { :require=>"aws/ses" }
gem "comma"
gem "devise"
gem "devise-encryptable"
gem "devise_invitable"
gem "dynamic_form"
gem "google-analytics-rails"
gem "httparty"
gem "mimemagic", "0.3.10"
gem "mysql2"
gem "nokogiri"
gem "paperclip"
gem "s3_direct_upload"
gem "settingslogic"
gem "tinymce-rails"
gem "omniauth"
gem "omniauth-oauth"
gem "xpath"
gem "will_paginate"

group :test do
  gem "capybara"
  gem "cucumber"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "launchy"
  gem "rails-controller-testing"
  gem "rspec"
  gem "selenium-webdriver"
  # Workaround for cc-test-reporter with SimpleCov 0.18.
  # Stop upgrading SimpleCov until the following issue will be resolved.
  # https://github.com/codeclimate/test-reporter/issues/418
  gem "simplecov", "~> 0.10", "< 0.18", require: false
  gem "test-unit"                                # added to enable rspec on ruby 2.2/2.3
  gem "therubyracer", :platforms => :ruby
  gem "webdrivers"
end

group :development do
  gem "web-console"                              # enables <%= console %> helper in views and error pages
end

group :development, :test do
  gem "rspec-rails"
  gem "pry"
end

group :production do
  gem "unicorn"

  # for asset precompile
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "therubyracer", :platforms => :ruby
end
