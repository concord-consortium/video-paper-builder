# Upgrade Steps

This documents the steps taken to upgrade VPB from ruby 1.93/rails 3.2 to the latest ruby/rails version along with any of the issues found along the way.  This should be a good resource for other project upgrades.

## Steps Done

1. Setup Docker environment for development only
  a. No real issues found after using a combination of the docker setup from document-store and lara.
2. Setup Travis builds
    1. Had to set the Travis dist to precise to avoid mysql2 gem error because it doesn't support secure connections on Mysql 5.7, precise uses Mysql 5.5
    2. Had to upgrade bundler from the version (1.9.0) shipped with the ruby-1.9.3 Docker image to latest 1.x version via `gem install bundler -v '~>1'` in the Dockerfile.  Without this upgrade the test gems where not loading when running the tests locally in the docker container but were running in Travis.
    3. Had to comment out require of `ruby-debug`.  I think the cucumber tests were
    4. Had to install Firebox and xvfb to get cucumber tests to run.  Because the ruby-1.9.3 Docker image is based on Debian 8 I had to add the Linux Mint repository to install Firebox in the Dockerfile.
3. Setup Docker tests
    1. Currently the cucumber tests are broken due to Firefox not being executable due to a library dependency issue after installing an old version of Firefox (19). Currently leaving this as an open issue until after I can upgrade to the latest rails 3.2 and latest ruby version supported by 3.2 so that I can get a newer Firefox version.
4. Setup CodeClimate
    1. Had to add SimpleCov to `env.rb` and `spec_helper.rb`
    2. Had to exclude lots of files that will never have test coverage (assets, erb templates, etc) to clean up the CodeClimate dashboard
    3. Had to copy in the CodeClimate setup from Lara
5. Look at test coverage (see "Starting Code Coverage" table below)
6. Ensure test coverage
7. Setup temp staging server for manual testing
    1. Used AWS Lightsail instance, installed docker and docker-compose and ran `docker-compose up -d` to start the server.
    2. Pointed `vpb-temp.staging.concord.org` to the Lightsail instance.
8. Update to last 3.2 version of rails (3.2.22.5)
    1. Upgraded by updating rails version in Gemfile and running `bundle update rails --patch` inside a `/bin/bash` session in the app Docker container.  Had to remove capistrano and capistrano-maintenance dependencies as they are no longer used and prevented the upgrade because the capistrano-maintenance -> capistrano -> airbrussh -> sshkit -> net-scp -> net-ssh transitive dependency could not update.
9. Audit all dependencies to see if any are not used (see "Dependency Versions" table below)
10. Upgrade to Rails 4.2.11.1 / ruby >= 1.9.3
    1. Remove rails 2.3 style vendor/plugins (https://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released/)
    2. Removed unused gems found in audit
    3. Set ruby version in Gemfile to ruby '1.9.3' and run bundle platform and bundle check and bundle install to validate gem versions
    4. Remove all gem versions for gems that haven't done a major upgrade except rails (keep at 3.2.22.5) to see what versions bundler picks (update: had to pin a bunch of gems so they wouldn't upgrade to ruby 2 versions)
    5. Update to ruby 2.2 (should have done this first).  Had to clean out /bundle volume on Docker container to get it to work as there were old libraries in there causing segfaults.  Also had to add `test-unit` gem to enable rspec to work on ruby 2.2 (it adds a dependency that rspec 2 doesn't have that is needed in ruby 2.2).  Had to disable two instances of "can't modify frozen NilClass" in rspec tests until rspec is upgraded to allow different stubbing.
    6. Started upgrade to Rails 4 but hit a wall.  rspec/rspec-rails needed to be updated due to changes from rails 3 -> 4 but when I did that it caused a lot of tests to fail.  I started fixing the tests and then I realized that the real fix was the rspec upgrade.  There is an automated upgrade gem called `transpec` however it requires green tests.  So I stashed the 4.0 upgrade and started the rspec upgrade but it turns out `transpec` needs ruby 2.3 which is not supported in rails 4.0 but is in rails 4.1.  So the new plan is to upgrade ruby to 2.3 then upgrade rspec and then jump directly to rails 4.1.
    7. Upgrade to ruby 2.3.  Had to also upgrade to latest rspec 2 due to older rspec 2 throwing `private method `fixture_path' called` error
    8. Tried to upgrade rspec from 2 to 3 using `transpec` gem as outlined here: https://rspec.info/upgrading-from-rspec-2/.  At first I thought I needed to upgrade bundler as the transpec gem could not find the needed gems to run but that turned out not to be true.  Instead I needed to install `transpec` using the Gemfile and then run the following: `bundle exec transpec -c 'BUNDLE_PATH=/bundle RAILS_ENV=test bundle exec rspec'
    9. Had to upgrade Devise from 2 to 3 due to rails dependency change which caused a lot of issues due to how tokens are generated and stored in version 3.  I was able to pin to Devise 3.1 which reduced the amount of code change needed.
    10. Update rails from 4.0 to 4.1
    11. Update rails from 4.1 to 4.2
    12. Update to ruby 2.4.5
11. Upgrade to Rails 5.2.4.1 / ruby >= 2.2.2
    1. Update all dependencies (I first tried to update directly to rails 5 but bundler could not resolve).  This update actually went a lot smoother than I thought as many of the gems bumped major versions.  As of now with this step complete there are only 4 gems (rails included) that are not on latest.
    2. Remove protected_attributes gem and replace attr_accessible in models with strong parameters in controller
    3. Upgrade to rails 5.0.7.2
        1. Installed rubocop and used `bundle exec rubocop --only Rails/HttpPositionalArguments -a` to fix almost all deprecation warnings about positional argurments -- needed to change use of xhr first for the update to fix everything (which is deprecated).  Once the update was done I uninstalled rubocop.  More info here: https://stackoverflow.com/a/58095264
    4. Upgrade to rails 5.1.7
    5. Upgrade to rails 5.2.4.2

## Steps Todo


12. Upgrade to Rails 6.0.2.1 / ruby >= 2.5.0
13. Setup Docker environment for production?


## Starting Code Coverage (rails 3.2.11/ruby 2.1 ordered by final %)

|File                                 |Initial  |Final|
|-------------------------------------|---------|-----|
|app/controllers/admins_controller.rb|100%|100%|
|app/helpers/admins_helper.rb|100%|100%|
|app/helpers/application_helper.rb|100%|100%|
|app/helpers/videos_helper.rb|100%|100%|
|app/mailers/share_mailer.rb|100%|100%|
|app/models/admin.rb|100%|100%|
|app/models/settings.rb|100%|100%|
|app/models/shared_paper.rb|100%|100%|
|app/models/wysihat_file.rb|100%|100%|
|app/models/section.rb|97%|100%|
|app/models/schoology_realm.rb|85%|100%|
|app/controllers/application_controller.rb|82%|100%|
|app/controllers/registrations_controller.rb|71%|100%|
|app/controllers/users_controller.rb|70%|100%|
|app/helpers/home_helper.rb|66%|100%|
|app/helpers/video_papers_helper.rb|61%|100%|
|app/models/user.rb|61%|100%|
|app/models/video.rb|56%|100%|
|app/models/video_paper.rb|92%|100%|
|app/controllers/home_controller.rb|45%|100%|
|app/controllers/videos_controller.rb|43%|100%|
|app/controllers/video_papers_controller.rb|72%|99% (can't test admin login)|
|lib/omni_auth/strategies/schoology.rb|0%|90% (did not test redirects)|
|app/controllers/sns_controller.rb|20%|47% (needs rails upgrade to test json posts)|
|app/controllers/wysihat_files_controller.rb|30%|30% (will be deleted)|
|app/controllers/authentications_controller.rb|22%|22% (needs rspec upgrade to test)|
|lib/invite_csv.rb|0%|0% (not needed, used in one-off rake task)|
|app/assets/javascripts/application.js|0%|0% (not needed for rails/ruby upgrade)|
|app/assets/javascripts/aws-upload.js|0%|0% (not needed for rails/ruby upgrade)|

## Dependency Versions

| |gem                      |Environment|Latest  |Latest Ruby|Initial 3|Final 3  |Final 4  |
|-|-------------------------|-----------|--------|-----------|---------|---------|---------|
|X|capistrano               |all        |3.12.1  |>= 2.0     |2.14.1   |*removed*|--       |
|X|capistrano-maintenance   |all        |1.2.1   |>= 0       |0.0.2    |*removed*|--       |
|X|coffee-rails             |assets     |5.0.0   |>= 0       |3.2.2    |3.2.2    |*removed*|
|X|debugger                 |dev        |1.6.8   |>=0        |1.6.8    |1.6.8    |*removed*|
|X|debugger-ruby_core_source|dev        |1.3.8   |>= 0       |*added*  |1.3.8    |*removed*|
|X|exception_notification   |all        |4.4.0   |>= 2.0     |3.0.0    |3.0.0    |*removed*|
|X|rdoc                     |all        |6.2.1   |>= 2.4.0   |3.12     |3.12.2   |*removed*|
|X|sass-rails               |assets     |6.0.0   |>= 0       |3.2.6    |3.2.6    |*removed*|
|X|turbo-sprockets-rails3   |assets     |0.3.14  |>= 0       |0.3.6    |0.3.6    |*removed*|
|X|uglifier                 |assets     |4.2.0   |>= 1.9.3   |1.3.0    |1.3.0    |*removed*|
|X|warden                   |all        |1.2.8   |>= 0       |1.2.1    |1.2.1    |*removed*|
|X|tinymce-rails-imageupload|all        |3.5.8.6 |NONE       |3.5.6.4  |3.5.6.4  |*removed*|
|X|aws-sdk                  |all        |3.0.1   |>= 0       |1.66.0   |1.66.0   |*removed*|
|Y|aws-sdk-s3               |all        |1.61.1  |>= 0       |--       |--       |1.61.1   |
|Y|aws-sdk-elastictranscoder|all        |1.19.0  |>= 0       |--       |--       |1.19.0   |
|Y|capybara                 |test       |3.32.0  |>= 2.4.0   |1.1.4    |1.1.4    |3.32.0   |
|Y|comma                    |all        |4.3.2   |>= 0       |3.0.4    |3.0.4    |4.3.2    |
|Y|cucumber                 |test       |3.1.2   |>= 2.2     |1.1.9    |1.1.9    |3.1.2    |
|Y|cucumber-rails           |test       |2.0.0   |>= 2.3.0   |1.3.0    |1.3.0    |2.0.0    |
|Y|database_cleaner         |test       |1.8.3   |>= 1.9.3   |0.7.2    |0.7.2    |1.8.3    |
|Y|devise                   |all        |4.7.1   |>= 2.1.0   |2.2.3    |2.2.3    |4.7.1    |
|Y|devise-encryptable       |all        |0.2.0   |>= 0       |0.1.1    |0.1.1    |0.2.0    |
|Y|devise_invitable         |all        |2.0.1   |>= 2.2.2   |1.1.5    |1.1.5    |2.0.1    |
|Y|dynamic_form             |all        |1.1.4   |NONE       |1.1.4    |1.1.4    |1.1.4    |
|Y|google-analytics-rails   |all        |1.1.1   |>= 1.9.3   |1.0.0    |1.0.0    |1.1.1    |
|Y|httparty                 |all        |0.18.0  |>= 2.0.0   |0.10.2   |0.10.2   |0.18.0   |
|Y|jquery-rails             |all        |4.3.5   |>= 1.9.3   |2.2.0    |2.2.0    |4.3.5    |
|Y|jquery-ui-rails          |all        |6.0.1   |>= 0       |4.0.0    |4.0.0    |6.0.1    |
|Y|launchy                  |test       |2.5.0   |>= 2.4.0   |2.1.2    |2.1.2    |2.5.0    |
|Y|mysql2                   |all        |0.5.3   |>= 2.0.0   |0.3.15   |0.3.15   |0.5.3    |
|Y|nokogiri                 |all        |1.10.9  |>= 2.3.0   |1.5.6    |1.5.6    |1.10.9   |
|Y|paperclip                |all        |6.1.0   |>= 2.1.0   |3.4.0    |3.4.0    |6.1.0    |
|Y|protected_attributes     |all        |1.1.4   |>= 0       |--       |--       |1.1.4    |
|Y|rspec                    |test       |3.9.0   |>= 0       |2.11.0   |2.11.0   |3.9.0    |
|Y|rspec-rails              |dev & test |4.0.0   |>= 0       |2.11.4   |2.11.4   |4.0.0    |
|Y|s3_direct_upload         |all        |0.1.7   |NONE       |0.1.7    |0.1.7    |0.1.7    |
|Y|selenium-webdriver       |test       |3.142.7 |>= 2.3     |2.31.0   |2.31.0   |3.142.7  |
|Y|settingslogic            |all        |2.0.9   |NONE       |2.0.9    |2.0.9    |2.0.9    |
|Y|test-unit                |test       |3.3.5   |>= 0       |--       |--       |3.3.5    |
|Y|therubyracer             |test       |0.12.3  |>= 0       |0.12.1   |0.12.1   |0.12.3   |
|Y|tinymce-rails            |all        |5.2.1   |>= 0       |3.5.8    |3.5.8    |5.2.1    |
|Y|omniauth                 |all        |1.9.1   |>= 2.2     |1.1.4    |1.1.4    |1.9.1    |
|Y|omniauth-oauth           |all        |1.1.0   |>= 0       |1.1.0    |1.1.0    |1.1.0    |
|Y|xpath                    |all        |3.2.0   |>= 2.3     |0.1.4    |0.1.4    |3.2.0    |
|Y|webdrivers               |test       |4.2.0   |>= 0       |--       |--       |4.2.0    |
|Y|will_paginate            |all        |3.3.0   |>= 2.0     |3.0.4    |3.0.4    |3.3.0    |
|N|factory_(girl/bot)_rails |test       |5.1.2   |>= 0       |4.2.0    |4.2.0    |5.1.1    |
|N|rails                    |all        |6.0.2.2 |>= 2.5.0   |3.2.11   |3.2.22.5 |5.2.4.2  |
|N|simplecov                |test       |0.18.5  |>= 2.4.0   |*added*  |0.9.2    |0.17.1   |
|N|web-console              |dev        |4.0.1   |>= 2.5     |--       |--       |3.3.0    |

## Note about ruby versions supported

Prior to 9th April 2019, stable branches of Rails since 3.0 use travis-ci for automated testing, and the list of tested ruby versions, by rails branch, is:

### Rails 4.0

- 1.9.3
- 2.0.0
- 2.1
- 2.2

### Rails 4.1

- 1.9.3
- 2.0.0
- 2.1
- 2.2.4
- 2.3.0

### Rails 4.2

- 1.9.3
- 2.0.0-p648
- 2.1.10
- 2.2.10
- 2.3.8
- 2.4.5

### Rails 5.0

- 2.2.10
- 2.3.8
- 2.4.5

### Rails 5.1

- 2.2.10
- 2.3.7
- 2.4.4
- 2.5.1

### Rails 5.2

- 2.2.10
- 2.3.7
- 2.4.4
- 2.5.1

### Rails 6.0

- 2.5.3
- 2.6.0
