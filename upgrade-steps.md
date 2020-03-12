# Upgrade Steps

This documents the steps taken to upgrade VPB from ruby 1.93/rails 3.2 to the latest ruby/rails version along with any of the issues found along the way.  This should be a good resource for other project upgrades.

## Steps Done

1. Setup Docker environment for development only
  a. No real issues found after using a combination of the docker setup from document-store and lara.
  b. I did have to add a docker version of the aws config and set it in the .gitignore file.  This file is copied in the `docker-run-dev.sh` script in the same way as the database.yml file is copied.

## Steps Todo

2. Setup Travis builds
3. Update test gems to latest version supported by 1.9.3/3.2
4. Setup CodeClimate on repo
5. Look at test coverage and add tests for all happy paths
6. Remove rails 2.3 style vendor/plugins (https://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released/)
7. Upgrade to Rails 4
8. Upgrade to Rails 5
9. Upgrade to Rails 6
9. Setup Docker environment for production?
