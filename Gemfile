source "http://rubygems.org"
ruby "2.3.0"

# TODO: remove these gems after ruby upgrades
gem "rubyzip", "0.9.9"           # pin to ensure cucumber-rails doesnt resolve to using ruby 2.4

# TODO: remove this gem when rspec is upgraded
gem 'rake', '< 11.0'             # Rake 11.0.1 removes the last_comment method which Rails rspec-core (< 3.4.4) uses

gem "rails", "~> 3.2.22.5"       # MAJOR UPGRADE NEEDED: latest is 6.0.2.2
gem "jquery-rails", "~> 2.1"     # MAJOR UPGRADE NEEDED: latest is 4.3.5
gem "jquery-ui-rails", "~> 4.0"  # MAJOR UPGRADE NEEDED: latest is 6.0.1

gem "aws-sdk", "~> 1.66"         # MAJOR UPGRADE NEEDED: latest is 3.0.1
gem "comma", "~> 3.0"            # MAJOR UPGRADE NEEDED: latest is 4.3.2
gem "devise", "~> 2"             # MAJOR UPGRADE NEEDED: latest is 4.7.1
gem "devise-encryptable"
gem "devise_invitable", "~> 1"   # MAJOR UPGRADE NEEDED: latest is 2.0.1
gem "dynamic_form"
gem "google-analytics-rails"     # latest is 1.1.1, original was 1.0.0
gem "httparty"
gem "mysql2", "0.3.15"           # pin to ensure mysql2 doesnt resolve to rails 4 version; latest is 0.5.3, original was ~> 0.3.15, 0.4.9
gem "nokogiri", "1.9.1"          # pin to ensure aws-sdk doesnt resolve to using ruby > 2.2
gem "paperclip", "~> 3"          # MAJOR UPGRADE NEEDED: latest is 6.1.0
gem "s3_direct_upload"           # latest is 0.1.7, original was ~> 0.1.7
gem "settingslogic"
gem "tinymce-rails", "~> 3"      # MAJOR UPGRADE NEEDED: latest is 5.2.0
gem "tinymce-rails-imageupload"  # latest is 3.5.8.6, original was ~> 3.5.6.3
gem "omniauth", '~> 1.1.4'       # latest is 1.9.1, if left unpinned there is a frozen string error thrown at startup
gem "omniauth-oauth"             # latest is 1.1.0, original was ~> 1.1.0
gem "xpath"
gem "will_paginate", "3.0.4"     # pinned otherwise fix needed for `unsupported parameters: :order` in video_papers_controller.rb

group :test do
  gem "capybara", "2.18.0"                             # MAJOR UPGRADE NEEDED: latest is 3.31.0
  gem "cucumber",           "~> 1.0"                   # MAJOR UPGRADE NEEDED: latest is 3.1.2, original was ~> 1.1.9
  gem "cucumber-rails",     "~> 1.0", require: false   # MAJOR UPGRADE NEEDED: latest is 2.0.0
  gem "database_cleaner",   "~> 0.7.2"                 # MAJOR UPGRADE NEEDED: latest is 1.8.3
  gem "factory_girl_rails"                             # latest is 4.9.0, original was ~> 4.0
  gem "launchy",            "~> 2.4.0"                 # lastest is 2.5.0 but it requires > ruby 2.2
  gem "rspec",              "~> 2.0"                   # MAJOR UPGRADE NEEDED: latest is 3.9.0
  gem "selenium-webdriver"
  gem "simplecov", "~> 0.9.1", require: false          # latest is 0.18.5, can"t upgrade until rspec-rails is upgraded
  gem "test-unit"                                      # added to enable rspec on ruby 2.2
  gem 'therubyracer', '~> 0.12.1', :platforms => :ruby
end

group :development, :test do
  gem "rspec-rails",        "~> 2.0"   # MAJOR UPGRADE NEEDED: latest is 3.9.1
end
