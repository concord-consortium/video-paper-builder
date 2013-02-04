require 'capistrano/ext/multistage'
require 'bundler/capistrano'

def source_branch(default)
  ENV['BRANCH'] or default
end

set :stages, %w(development staging production)
set :default_stage, "development"
default_run_options[:pty] = true
set :use_sudo, false

set :scm, :git
set :repository,  "git://github.com/concord-consortium/video-paper-builder.git"

after 'deploy:update_code',   'deploy:link_database_yml'
after 'deploy:update_code',   'deploy:link_kaltura_yml'
namespace(:deploy) do

  task :link_database_yml do
    run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end  

  task :link_kaltura_yml do
    run "ln -nsf #{shared_path}/config/kaltura.yml #{release_path}/config/kaltura.yml"
  end 

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


 namespace :deploy do

 end
