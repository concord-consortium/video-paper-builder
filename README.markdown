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

    $ rvm --rvmrc 2.6.6
    $ cd ..; cd -

### Run bundler install

    $ bundle install

### Setup AWS connection

TODO

### Setup database

1. Copy config/database.example.yml to config/database.yml
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

Docker (Development)
---------------------

Create an `.env` file and set the following values:

```
DEVISE_SECRET_KEY=  (use `rake secret` to generate)
SECRET_KEY_BASE=  (use `rake secret` to generate)
ACCESS_KEY_ID=  (AWS access key)
SECRET_ACCESS_KEY=  (AWS secret access key)
S3_BUCKET=  (AWS bucket)
S3_REGION=  (AWS region)
PIPELINE_ID=  (AWS Elastic Transcoder pipeline ID)
RDS_DB_NAME=video_paper_builder_prod
RDS_USERNAME=root
RDS_PASSWORD=xyzzy
RDS_HOSTNAME=db
RDS_PORT=3306
```

Run the command: `docker-compose up` to start the server.

The server should then be available at:

http://localhost:3000

To create the initial admin user run: `docker-compose run app /bin/bash -c "bundle exec rails c"`

and then type in the following with the values changed in the rails console:

```
Admin.create! do |u|
      u.first_name = 'CHANGE'
      u.last_name = 'CHANGE'
      u.email = 'CHANGE'
      u.password = 'CHANGE'
      u.password_confirmation = 'CHANGE'
    end
```

finally change the confirmation url showing the console after the admin is created to use localhost and then load that url in your browser (while the server is running) to confirm the admin.

Running Tests in Docker
-----------------------

$ docker-compose run -e RAILS_ENV=test app /bin/bash -c "/vpb/test.sh"

Running on Port 80 in Docker
----------------------------

To use port 80 instead of port 3000 for the webserver with docker-compose create a file named `.env` (it is already in `.gitignore`) and add the following content:

```
COMPOSE_FILE=docker-compose.yml:docker-compose-port-80.yml
```

then restart docker-compose. If you have issues you may need to disable an existing webserver running on port 80.


Docker (Local Production Test)
---------------------

Create an `.env` file and set the following values (NOTE: the RDS_ values must match those in the `docker-compose-local-prod.yml` file):

```
DEVISE_SECRET_KEY=  (use `rake secret` to generate)
SECRET_KEY_BASE=  (use `rake secret` to generate)
ACCESS_KEY_ID=  (AWS access key)
SECRET_ACCESS_KEY=  (AWS secret access key)
S3_BUCKET=  (AWS bucket)
S3_REGION=  (AWS region)
PIPELINE_ID=  (AWS Elastic Transcoder pipeline ID)
RDS_DB_NAME=video_paper_builder_prod
RDS_USERNAME=root
RDS_PASSWORD=xyzzy
RDS_HOSTNAME=db
RDS_PORT=3306
SES_KEY=  (AWS SES key if you want to enable email)
SES_SECRET=  (AWS SES secret if you want to enable email)
MAILER_HOSTNAME=localhost  (or change to use different hostname in sent emails)
DEBUG_PRODUCTION=  (true or false, true will log like development mode)
```

Run the command: `docker-compose -f docker-compose-local-prod.yml build` to create the image.

Run the command: `docker-compose -f docker-compose-local-prod.yml run --rm prod_app /bin/bash` and inside the bash session run `./docker/prod/prod-run.sh migrate` to create and migrate the database.

Run the command: `docker-compose -f docker-compose-local-prod.yml up` to start the server.

The server should then be available (via nginx proxying to the app running under unuicorn) at:

http://localhost/

(if you have issues you may need to disable an existing webserver running on port 80)

To create the initial admin user run: `docker-compose -f docker-compose-local-prod.yml run --rm prod_app /bin/bash -c "bundle exec rails c"`

and then type in the following with the values changed in the rails console:

```
Admin.create! do |u|
      u.first_name = 'CHANGE'
      u.last_name = 'CHANGE'
      u.email = 'CHANGE'
      u.password = 'CHANGE'
      u.password_confirmation = 'CHANGE'
    end
```

finally change the confirmation url showing the console after the admin is created to use localhost and then load that url in your browser (while the server is running) to confirm the admin.

Elastic Transcoder and SNS Notifications
----------------------------------------

In production or development to enable transcoder notifications back to the application you must add a subscription for the web endpoint using the AWS web ui.  If you do not do this you will see the VPB web ui wait forever for notification that the video has been transcoded.

1. Load https://console.aws.amazon.com/sns/v3/home?region=us-east-1#/topic/arn:aws:sns:us-east-1:612297603577:vpb-transcoder-progress
2. Click the "Create subscription" button
3. Select either http or https as the protocol (depending on your deployment)
4. Add the SNS endpoint url whose path is `/sns/transcoder_update`, eg http://example.com/sns/transcoder_update

Bulk Invite of Users
--------------------

There is a `invite_example` rake task in `lib/tasks/invite.take` that defines two constants at the top of the file:

```
VIDEO_PAPER_ID = 1
INVITE_CSV_PATH = '/vpb/tmp/invite_list.csv'
```

To bulk invite users in the current AWS Fargate deployment configuration you will need to set those constants and then run a local Docker instance with the `.env` file settings (as outlined above in "Docker (Local Production Test)") set to the parameter values in the `video-paper-builder` CloudFormation stack on production.

The RDS instance security group will need to temporarily be changed to allow ingress from your IP using the AWS GUI.  To do this, [load this page](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#ModifyInboundSecurityGroupRules:securityGroupId=sg-0baea37f250d879b8), click the "Add rule" button and then in the "Source" dropdown select "My IP" and then save the rule.  Once you have completed the invite process you should remove the ingress access from your IP by deleting the rule using the link above.

Once you have the `.env` file set and the IP ingress enabled run the local production test setup as outlined above and then run the following:

`docker-compose -f docker-compose-local-prod.yml up` to start the server.  Once you start the server, as a check of the mailer, invite a user using a mailing address you have access to and then check to ensure the mail is delivered and has the correct hostname (pointing to the real production server url).  After you have verified this run the following:

`docker-compose -f docker-compose-local-prod.yml run --rm prod_app /bin/bash` and inside the bash session run `bundle exec rake invite_example` to run the rake task.

The rake task sleeps for 0.4 seconds per invite to stay well under the limit of 5 emails per second through SES.


License
-------

Currently under MIT license
