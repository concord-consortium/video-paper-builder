source "http://rubygems.org"

gem 'rails', '~> 3.2'
gem 'jquery-rails', '~> 2.1'
gem 'jquery-ui-rails', '~> 4.0'

gem "mysql2", '~>0.3.15'

gem 'velir_kaltura-ruby', '~> 0.4.3', :require=> 'kaltura'
gem 'devise'
gem 'devise_invitable'
gem 'devise-encryptable'
gem 'warden'
gem 'paperclip'
gem 'aws-sdk', '~> 1.66'
gem 'settingslogic'
# gem 'wysihat-engine', '0.1.12'
gem 'will_paginate'
gem 'capistrano'
gem 'capistrano-maintenance'
gem 'nokogiri'
gem 'xpath', "~> 0.1.4"
gem 'exception_notification'
gem 'rdoc'
gem "dynamic_form"
gem "tinymce-rails"
gem 'tinymce-rails-imageupload', '~> 3.5.6.3'
gem "comma", "~> 3.0"
gem 's3_direct_upload', "~> 0.1.7"
gem 'httparty'
gem 'google-analytics-rails', '1.0.0'

group :development do
  gem 'debugger'
end

group :test do
  gem "selenium-webdriver", "2.31.0"
  gem "cucumber",           "~> 1.1.9"
  gem "cucumber-rails",     "~> 1.3.0", :require => false
  gem "database_cleaner",   "~> 0.7.2"
  gem "capybara",           "~> 1.1.2"
  gem "rspec",              "~> 2.11.0"
  gem "factory_girl_rails", "~> 4.0"
  gem 'launchy'
#   gem 'spork'
#   gem 'autotest-rails'
#   gem 'redgreen'
end

group :development, :test do
  gem "rspec-rails",        "~> 2.11.0"
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.1', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "turbo-sprockets-rails3", "~> 0.3.6"
end

# group :production do
#   gem 'rmagick', '~> 1.15.17'
# end
