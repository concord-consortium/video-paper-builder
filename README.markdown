Video Paper Builder
===================

A Rails application for creating and viewing video papers.

[Concord Consortium](http://www.concord.org)

Installation:
-------------

### Check out the application

    $ git clone git://github.com/concord-consortium/video-paper-builder.git
    $ cd video-paper-builder

### Use rvm

    $ rvm --rvmrc 1.9.3
    $ cd ..; cd -

### Run bundler install

    $ bundle install

### Setup AWS connection

TODO

### Setup database

1. Copy config/database.yml.example to config/database.yml
2. Update username and password
3. Run rake db:create:all
4. Run rake db:migrate

### Test

    $ rake spec
    $ rake cucumber

### Server

    $ rails s

### Uploading Help Video

TODO: Update
This [Jing video](http://screencast.com/t/lxUHFk3a) describes how to add more.

## Customizing Edit Notes Tab Labels

To customize the labels for the tabs in the Edit Notes page edit the title property of the
sections setting in the config/application.yml file.  By default the title settings are:

    defaults: &defaults
      sections:
        a:
          title: Introduction
        b:
          title: Lesson
        c:
          title: Student Work
        d:
          title: Results
        e:
          title: Conclusion

Configuration Notes
-------------------

I have a theory that if the `AWS_*` env variables are not set then the signed video URLs do not work correctly until someone tries to upload a video. This is because the S3 uploader is configured with these credentials which probably then calls AWS.config with them. And then that global config picked up by everything else.

Docker
------

Create config/aws.yml.docker from config/aws.yml.example and fill in the configuration.  This config/aws.yml.docker file is set in the .gitignore file.

Run the command: `docker-compose up`

Document server should be available at:

http://localhost:3000


License
-------

Currently under MIT license
