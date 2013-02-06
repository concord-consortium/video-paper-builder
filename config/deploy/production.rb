set :application, "vpb"
set :branch,  source_branch('master')
set :deploy_to, "/web/portal"
set :user, 'deploy'

# set :password
# Add public keys to the deploy users authorized list.
server 'vpb.concord.org', :app, :web, :db, :primary=>true
