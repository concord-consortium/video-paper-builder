Video Paper Builder
===================

A Rails application for creating and viewing video papers.

[Concord Consortium](http://www.concord.org)

Installation:
-------------

Check out the application:

    $ git clone git://github.com/concord-consortium/video-paper-builder.git
    $ cd video-paper-builder

Use rvm:

    $ rvm --rvmrc 1.9.3
    $ cd ..; cd -

Run bundler install:

    $ bundle install

Test:

    $ rake spec
    $ rake cucumber

Profit!

    $ rails s

Uploading Help Video:

    [Jing Video](http://screencast.com/t/lxUHFk3a)
    An addendum to this is that you should delete the flavors that were created automatically. Otherwise the play will use a lower quality flavor
    and the video will look blurry.


License
-------

Currently under MIT license