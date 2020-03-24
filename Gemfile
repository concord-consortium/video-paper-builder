source "http://rubygems.org"
ruby "1.9.3"

# TODO: remove these gems after ruby upgrades
gem "rake", "10.0.4"             # pin to ensure s3_direct_upload doesn"t resolve to using ruby 2
gem "coffee-rails", "3.2.2"      # pin to ensure s3_direct_upload doesnt resolve to using ruby 2
gem "thor", "0.17.0"             # pin to ensure s3_direct_upload doesnt resolve to using ruby 2
gem "sass", "3.2.5"              # pin to ensure s3_direct_upload doesnt resolve to using ruby 2
gem "rack-cache", "1.2"          # pin to ensure devise_invitable doesnt resolve to using ruby 2
gem "addressable", "2.3.3"       # pin to ensure launchy doesnt resolve to using ruby 2
gem "childprocess", "0.3.9"      # pin to ensure cucumber-rails doesnt resolve to using ruby 2
gem "ffi", "1.4.0"               # pin to ensure cucumber-rails doesnt resolve to using ruby 2
gem "rubyzip", "0.9.9"           # pin to ensure cucumber-rails doesnt resolve to using ruby 2
gem "term-ansicolor", "1.0.7"    # pin to ensure cucumber-rails doesnt resolve to using ruby 2
gem "oauth", "0.4.7"             # pin to ensure omniauth-oauth doesnt resolve to using ruby 2

# TODO: keep these gems but remove version requirement
gem "nokogiri", "1.5.6"          # pin to ensure aws-sdk doesnt resolve to using ruby 2
gem "httparty", "0.14.0"         # pin to ensure httparty doesnt resolve to using ruby 2
gem "mysql2", "0.3.15"           # pin to ensure mysql2 doesnt resolve to using ruby 2; latest is 0.5.3, original was ~> 0.3.15, 0.4.9
gem "will_paginate", "3.0.4"     # pinned otherwise fix needed for `unsupported parameters: :order` in video_papers_controller.rb

gem "rails", "~> 3.2.22.5"       # MAJOR UPGRADE NEEDED: latest is 6.0.2.2
gem "jquery-rails", "~> 2.1"     # MAJOR UPGRADE NEEDED: latest is 4.3.5
gem "jquery-ui-rails", "~> 4.0"  # MAJOR UPGRADE NEEDED: latest is 6.0.1

gem "devise", "~> 2"             # MAJOR UPGRADE NEEDED: latest is 4.7.1
gem "devise_invitable", "~> 1"   # MAJOR UPGRADE NEEDED: latest is 2.0.1
gem "devise-encryptable"
gem "omniauth", '~> 1.1.4'       # latest is 1.9.1, if left unpinned there is a frozen string error thrown at startup
gem "omniauth-oauth"             # latest is 1.1.0, original was ~> 1.1.0
gem "paperclip", "~> 3"          # MAJOR UPGRADE NEEDED: latest is 6.1.0
gem "aws-sdk", "~> 1.66"         # MAJOR UPGRADE NEEDED: latest is 3.0.1
gem "settingslogic"
gem "xpath", "~> 0.1.4"          # MAJOR UPGRADE NEEDED: latest is 3.2.0
gem "dynamic_form"
gem "tinymce-rails", "~> 3"      # MAJOR UPGRADE NEEDED: latest is 5.2.0
gem "tinymce-rails-imageupload"  # latest is 3.5.8.6, original was ~> 3.5.6.3
gem "comma", "~> 3.0"            # MAJOR UPGRADE NEEDED: latest is 4.3.2
gem "s3_direct_upload"           # latest is 0.1.7, original was ~> 0.1.7
gem "google-analytics-rails"     # latest is 1.1.1, original was 1.0.0

group :test do
  gem "selenium-webdriver", "2.31.0"                   # MAJOR UPGRADE NEEDED: latest is 3.142.7
  gem "cucumber",           "~> 1.1.9"                 # MAJOR UPGRADE NEEDED: latest is 3.1.2
  gem "cucumber-rails",     "~> 1.3.0", require: false # MAJOR UPGRADE NEEDED: latest is 2.0.0
  gem "database_cleaner",   "~> 0.7.2"                 # MAJOR UPGRADE NEEDED: latest is 1.8.3
  gem "capybara",           "~> 1.1.2"                 # MAJOR UPGRADE NEEDED: latest is 3.31.0
  gem "rspec",              "~> 2.11.0"                # MAJOR UPGRADE NEEDED: latest is 3.9.0
  gem "factory_girl_rails"                             # latest is 4.9.0, original was ~> 4.0
  gem "launchy"
  gem "simplecov", "~> 0.9.1", require: false          # latest is 0.18.5, can"t upgrade until rspec-rails is upgraded
  gem 'therubyracer', '~> 0.12.1', :platforms => :ruby
end

group :development, :test do
  gem "rspec-rails",        "~> 2.11.0"   # MAJOR UPGRADE NEEDED: latest is 3.9.1
end
