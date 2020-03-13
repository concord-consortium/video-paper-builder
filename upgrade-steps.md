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

## Steps Todo

4. Update to last 3.2 version of rails
5. Update to latest ruby version supported by 3.2
5. Update test gems to latest version supported by 1.9.3/3.2
6. Setup CodeClimate on repo
7. Look at test coverage and add tests for all happy paths
8. Remove rails 2.3 style vendor/plugins (https://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released/)
9. Upgrade to Rails 4
10. Upgrade to Rails 5
11. Upgrade to Rails 6
12. Setup Docker environment for production?
