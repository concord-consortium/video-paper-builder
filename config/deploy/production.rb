set :application, "vpb"
set :branch,  source_branch('master')
set :deploy_to, "/var/www/#{application}/production"
set :gateway, "otto.concord.org"
set :rails_env,:production
set :user, 'deploy'

# set :password
# Add public keys to the deploy users authorized list.
server 'kaltura-webapp.concord.org', :app, :web, :db, :primary=>true
