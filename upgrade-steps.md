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

## Steps Todo

7. Update to last 3.2 version of rails (3.2.22.5)
8. Setup staging server for manual testing
9. Audit all dependencies to see if any are not used
10. Upgrade to Rails 4.2.11.1 / ruby >= 1.9.3
    1. Remove rails 2.3 style vendor/plugins (https://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released/)

11. Upgrade to Rails 5.2.4.1 / ruby >= 2.2.2
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


