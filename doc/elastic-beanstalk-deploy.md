This app can be deployed on AWS Elastic Beanstalk.

Deploy a new version
--------------------

You can use `eb deploy [application-name]`
This will deploy the latest head commit in your local repository.
It checks out this head commit, zips it up, uploads it, and deploys it.

Scripts that run on elastic beanstalk
-------------------------------------

The `.ebextensions/setup.config` file is run by elastic beanstalk. This file injects a script into the standard
Elastic Beanstalk rails startup files. The script copies the relavant configuration files. The approach used here
is somewhat non-standard. Normally the config files would be checked into their final locations. EB also has
more standard ways to run scripts during app initialization, but these standard initialization scripts do not run before
the assets precompile step. And our assets precompile requires the configuration files to be in the right places.