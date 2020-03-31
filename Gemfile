source "http://rubygems.org"
ruby "2.4.5"

# TODO: remove these gems after ruby upgrades
# gem "rubyzip", "1.2.3"           # pin to ensure cucumber-rails doesnt resolve to using ruby 2.4
# gem "sassc", "1.12.1"             # pin to resolve build error on travis precise (cc1plus: error: unrecognized command line option ‘-std=c++11’)
gem "sprockets",                  "~> 3"  # pin to ensure s3_direct_upload doesnt resolve to using ruby 2.5

# TODO: remove this on rails 5 upgrade, adds attr_accessible & attr_protected removed in rails 4
gem "protected_attributes"

gem "rails",                      "~> 4.2.0"     # MAJOR UPGRADE NEEDED: latest is 6.0.2.2
gem "jquery-rails"
gem "jquery-ui-rails"

gem "aws-sdk-s3"
gem "aws-sdk-elastictranscoder"
gem "comma"
gem "devise",                     "~> 3"         # MAJOR UPGRADE NEEDED: latest is 4.7.1
gem "devise-encryptable"
gem "devise_invitable"
gem "dynamic_form"
gem "google-analytics-rails"
gem "httparty"
gem "mysql2"
gem "nokogiri"
gem "paperclip",                  "~> 3"         # MAJOR UPGRADE NEEDED: latest is 6.1.0
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
  gem "capybara",                 "~> 2.0"       # MAJOR UPGRADE NEEDED: latest is 3.31.0
  gem "cucumber",                 "~> 1.0"       # MAJOR UPGRADE NEEDED: latest is 3.1.2, original was ~> 1.1.9
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "launchy"
  gem "rspec",                    "~> 3.0"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "test-unit"                                # added to enable rspec on ruby 2.2/2.3
  gem "therubyracer", :platforms => :ruby
  gem "webdrivers"
end

group :development do
  gem "web-console"                              # enables <%= console %> helper in views and error pages
end

group :development, :test do
  gem "rspec-rails",              "~> 3.0"
end
