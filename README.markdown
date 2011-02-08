Video Paper Builder
===================

A Rails application for creating and viewing video papers.

[Concord Consortium](http://www.concord.org)

Installation:
-------------

Check out the application:

    $ git clone git://github.com/concord-consortium/video-paper-builder.git
    $ cd video-paper-builder

Use rvm gemsets:
    
    # We need to build image-magic.  Its hard to build on 1.9.2
    # So lets use 1.8.7 instead.
    
    $ rvm use 1.8.7
    $ rvm gemset create video_paper
    $ rvm use video_paper
    $ echo "rvm use 1.8.7@video_paper" > ./.rvmrc
    
Make sure you have bundler:
    
    $ gem install bundler
    
Run bundler install:

    $ bundle install
    
Test:

    $ rake db:test:prepare;rake devise:test RAILS_ENV=test;bundle exec spec spec/models/*.rb
    $ rake devise:test RAILS_ENV=test;bundle exec cucumber
    
Profit!

    $ script/server
    
License
-------

Currently under MIT license until told otherwise.