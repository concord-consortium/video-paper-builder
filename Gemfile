source "http://rubygems.org"
ruby "2.4.5"

# TODO: remove these gems after ruby upgrades
gem "sprockets",                  "~> 3"  # pin to ensure s3_direct_upload doesnt resolve to using ruby 2.5

gem "rails",                      "~> 5.1.0"     # MAJOR UPGRADE NEEDED: latest is 6.0.2.2
gem "jquery-rails"
gem "jquery-ui-rails"

gem "aws-sdk-s3"
gem "aws-sdk-elastictranscoder"
gem "comma"
gem "devise"
gem "devise-encryptable"
gem "devise_invitable"
gem "dynamic_form"
gem "google-analytics-rails"
gem "httparty"
gem "mysql2"
gem "nokogiri"
gem "paperclip"
gem "s3_direct_upload"
gem "settingslogic"
gem "tinymce-rails"
# TODO: enable/replace after all rails upgrades (it calls deprecated rake task at startup)
# gem "tinymce-rails-imageupload"
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
end
