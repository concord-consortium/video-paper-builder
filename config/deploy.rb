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
# uses a shared/cached_copy repository so the whole repo doesn't need to be cloned
# each time
set :deploy_via, :remote_cache

after 'deploy:update_code',   'deploy:link_configs'
namespace(:deploy) do

  task :link_configs do
    command = [ 'database', 'kaltura', 'mailer', 'paperclip', 'aws_s3'].map{|file|
      "ln -nsf #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
    }.join(' && ')

    run command
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


 namespace :deploy do

 end
