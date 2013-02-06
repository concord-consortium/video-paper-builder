require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano/maintenance'

def source_branch(default)
  ENV['BRANCH'] or default
end
set :rails_env, "production"
set :stages, %w(production staging)
set :default_stage, "need_to_specify_a_stage"
default_run_options[:pty] = true
set :use_sudo, false

set :scm, :git
set :repository,  "git://github.com/concord-consortium/video-paper-builder.git"

after 'deploy:update_code',   'deploy:link_configs'
namespace(:deploy) do

  task :link_configs do
    run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
         ln -nsf #{shared_path}/config/kaltura.yml #{release_path}/config/kaltura.yml &&
         ln -nsf #{shared_path}/config/mailer.yml #{release_path}/config/mailer.yml"
  end  

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


 namespace :deploy do

 end
