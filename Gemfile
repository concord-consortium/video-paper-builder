source "http://rubygems.org"
ruby "2.3.0"

# TODO: remove these gems after ruby upgrades
gem "rubyzip", "0.9.9"           # pin to ensure cucumber-rails doesnt resolve to using ruby 2.4
gem "sassc", "1.12.1"             # pin to resolve build error on travis precise (cc1plus: error: unrecognized command line option ‘-std=c++11’)

# TODO: remove this on rails 5 upgrade, adds attr_accessible & attr_protected removed in rails 4
gem "protected_attributes"

gem "rails",                      "~> 4.0.0"     # MAJOR UPGRADE NEEDED: latest is 6.0.2.2
gem "jquery-rails",               "~> 2.1"       # MAJOR UPGRADE NEEDED: latest is 4.3.5
gem "jquery-ui-rails",            "~> 4.0"       # MAJOR UPGRADE NEEDED: latest is 6.0.1

gem "aws-sdk",                    "~> 1.66"      # MAJOR UPGRADE NEEDED: latest is 3.0.1
gem "comma",                      "~> 3.0"       # MAJOR UPGRADE NEEDED: latest is 4.3.2
gem "devise",                     "~> 3.1.0"     # MAJOR UPGRADE NEEDED: latest is 4.7.1, > 3.2 changes how invitation tokens work and breaks a lot of code
gem "devise-encryptable"
gem "devise_invitable"
gem "dynamic_form"
gem "google-analytics-rails"
gem "httparty"
gem "mysql2",                     "~> 0.3.10"    # pin for rails 4
gem "nokogiri"
gem "paperclip",                  "~> 3"         # MAJOR UPGRADE NEEDED: latest is 6.1.0
gem "s3_direct_upload"
gem "settingslogic"
gem "tinymce-rails",              "~> 5"
# TODO: enable/replace after all rails upgrades (it calls deprecated rake task at startup)
# gem "tinymce-rails-imageupload"
gem "omniauth"
gem "omniauth-oauth"
gem "xpath"
gem "will_paginate",              "3.0.5"        # pinned otherwise fix needed for `unsupported parameters: :order` in video_papers_controller.rb

group :test do
  gem "capybara",                 "2.18.0"       # MAJOR UPGRADE NEEDED: latest is 3.31.0
  gem "cucumber",                 "~> 1.0"       # MAJOR UPGRADE NEEDED: latest is 3.1.2, original was ~> 1.1.9
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "launchy",                  "~> 2.4.0"     # latest is 2.5.0 but it requires >= ruby 2.4.0
  gem "rspec",                    "~> 3.0"
  gem "selenium-webdriver"
  gem "simplecov",                "~> 0.17.1", require: false # latest is 0.18.5, but > 0.17.1 requires ruby 2.4
  gem "test-unit"                                # added to enable rspec on ruby 2.2/2.3
  gem "therubyracer",             "~> 0.12.1", :platforms => :ruby
end

group :development, :test do
  gem "rspec-rails", "~> 3.0"
end
