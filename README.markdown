Video Paper Builder
===================

A Rails application for creating and viewing video papers.

[Concord Consortium](http://www.concord.org)

Installation:
-------------

Make sure you have bundler:
		
		$ gem install bundler
		
Check out the application:

		$ git clone git://github.com/concord-consortium/video-paper-builder.git
		$ cd video-paper-builder
		
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