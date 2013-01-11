source "http://rubygems.org"

gem 'bundler'
gem 'rails', '2.3.12'

if ENV['RB_MYSQL2']
  gem "mysql2",             "0.2.7"
else
  gem "mysql"
end

gem 'velir_kaltura-ruby', '~> 0.4.3', :require=> 'kaltura'
gem 'devise', '1.0.7'
gem 'devise_invitable', '0.2.3'
gem 'warden'
gem 'paperclip'
gem 'settingslogic'
gem 'wysihat-engine', '0.1.12'
gem 'will_paginate'
gem 'capistrano-ext'
gem 'nokogiri'
gem 'xpath'
gem 'exception_notification', '2.3.3.0'

group :development do
  gem 'ruby-debug'
end

group :test do
  gem 'capybara', "1.1.1"
  gem 'database_cleaner'
  gem 'cucumber-rails', "0.3.2"
  gem 'cucumber', "1.1.0"
  gem 'rspec' , '~>1.3.0'
  gem 'rspec-rails', '~>1.3.0'
  gem 'spork'
  gem 'launchy'
  gem 'autotest-rails'
  gem 'redgreen'
  gem 'factory_girl', '1.2.4'
end

group :production do
  gem 'rmagick', '~> 1.15.17'
end
