# Upgrade Steps

This documents the steps taken to upgrade VPB from ruby 1.93/rails 3.2 to the latest ruby/rails version along with any of the issues found along the way.  This should be a good resource for other project upgrades.

## Steps Done

1. Setup Docker environment for development only
  a. No real issues found after using a combination of the docker setup from document-store and lara.
2. Setup Travis builds
  a. Had to set the Travis dist to precise to avoid mysql2 gem error because it doesn't support secure connections on Mysql 5.7, precise uses Mysql 5.5
  b. Had to upgrade bundler from the version (1.9.0) shipped with the ruby-1.9.3 Docker image to latest 1.x version via `gem install bundler -v '~>1'` in the Dockerfile.  Without this upgrade the test gems where not loading when running the tests locally in the docker container but were running in Travis.
  c. Had to comment out require of `ruby-debug`.  I think the cucumber tests were
  d. Had to install Firebox and xvfb to get cucumber tests to run.  Because the ruby-1.9.3 Docker image is based on Debian 8 I had to add the Linux Mint repository to install Firebox in the Dockerfile.
3. Setup Docker tests
  a. Currently the cucumber tests are broken due to Firefox not being executable due to a library dependency issue after installing an old version of Firefox (19). Currently leaving this as an open issue until after I can upgrade to the latest rails 3.2 and latest ruby version supported by 3.2 so that I can get a newer Firefox version.
4. Setup CodeClimate
  a. Had to add SimpleCov to `env.rb` and `spec_helper.rb`
  b. Had to exclude lots of files that will never have test coverage (assets, erb templates, etc) to clean up the CodeClimate dashboard
  c. Had to copy in the CodeClimate setup from Lara
5. Look at test coverage and add tests for all happy paths (see below)

## Steps Todo

6. Update to last 3.2 version of rails
7. Update to latest ruby version supported by 3.2
8. Update test gems to latest version supported by 1.9.3/3.2
9. Remove rails 2.3 style vendor/plugins (https://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released/)
10. Upgrade to Rails 4
11. Upgrade to Rails 5
12. Upgrade to Rails 6
13. Setup Docker environment for production?


## Starting Code Coverage

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
|app/models/section.rb|97%|?|
|app/models/video_paper.rb|92%|?|
|app/models/schoology_realm.rb|85%|?|
|app/controllers/application_controller.rb|82%|?|
|app/controllers/video_papers_controller.rb|72%|?|
|app/controllers/registrations_controller.rb|71%|?|
|app/controllers/users_controller.rb|70%|?|
|app/helpers/home_helper.rb|66%|?|
|app/helpers/video_papers_helper.rb|61%|?|
|app/models/user.rb|61%|?|
|app/models/video.rb|56%|?|
|app/controllers/home_controller.rb|45%|?|
|app/controllers/videos_controller.rb|43%|?|
|app/controllers/wysihat_files_controller.rb|30%|?|
|app/controllers/authentications_controller.rb|22%|?|
|app/controllers/sns_controller.rb|20%|?|
|app/assets/javascripts/application.js|0%|?|
|app/assets/javascripts/aws-upload.js|0%|?|
|lib/invite_csv.rb|0%|?|
|lib/omni_auth/strategies/schoology.rb|0%|?|
|test/functional/home_controller_test.rb|0%|?|
|test/performance/browsing_test.rb|0%|?|
|test/test_helper.rb|0%|?|
|test/unit/helpers/home_helper_test.rb|0%|?|
|test/unit/language_test.rb|0%|?|
|test/unit/section_test.rb|0%|?|
|test/unit/share_mailer_test.rb|0%|?|

