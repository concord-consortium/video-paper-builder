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

### Setup kaltura connection

In most cases you will want to copy the kalutra.yml file from the production or staging server.
It is safe to do development with the same configuration settings as the real servers. Any uploaded
videos will go in either the 'dev', 'test', or 'cucumber' categories in the server.

If you can't get access to the CC real servers to get this kaltura.yml, then you'll need to setup your
own kaltura video server. This is a long and involved process, so avoid it if you can.

### Setup database

1. Copy config/database.yml.example to config/database.yml
2. Update username and password
3. Run rake db:create:all
4. Copy config/kaltura.yml.example to config/kaltura.yml
5. Optionally update kaltura configuration values (the kaltura.yml file just needs to exist for step 6)
6. Run rake db:migrate

### Test

    $ rake spec
    $ rake cucumber

### Server

    $ rails s

### Uploading Help Video

The code references some help videos that are uploaded to the CC kaltura server. This
[Jing video](http://screencast.com/t/lxUHFk3a) describeds how to add more. You'll need
admin access to the CC Kaltura server to do this.

An addendum to this is that you should delete the flavors that were created automatically.
Otherwise the player will use a lower quality flavor and the video will look blurry.

License
-------

Currently under MIT license
