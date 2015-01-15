# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'lbpark'
set :repo_url, 'git@github.com:arieso/lbpark.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/lbpark'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5 

set :rvm_type, :user
set :rvm_ruby_version, '2.1.4'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:all) do |host|
        execute "/etc/init.d/unicorn_lbpark #{command}"
      end
    end
  end

  task :change_lbpark_permission do
    on roles(:all) do |host|
      execute "chmod a+x #{current_path}/config/lbpark.sh"
    end
  end
  after "deploy:published", "deploy:change_lbpark_permission"


  task :setup_config do
    on roles(:all) do |host|
      sudo "ln -nfs #{current_path}/config/lbpark.conf /etc/nginx/sites-enabled/lbpark"
      sudo "ln -nfs #{current_path}/config/lbpark.sh /etc/init.d/unicorn_lbpark"
    end
  end
  after "deploy:published", "deploy:setup_config"

end




