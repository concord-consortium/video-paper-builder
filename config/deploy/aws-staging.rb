set :application, "vpb"
set :branch,  source_branch('rails-3.2')
set :deploy_to, "/web/portal"
set :user, 'deploy'

# set :password
# Add public keys to the deploy users authorized list.
server 'ec2-54-242-16-78.compute-1.amazonaws.com', :app, :web, :db, :primary=>true
