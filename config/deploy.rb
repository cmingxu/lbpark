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
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5 

set :rvm_type, :user
set :rvm_ruby_version, '2.1.5'
set :default_env, { rvm_bin_path: '/home/ubuntu/.rvm/bin' }

namespace :deploy do
  task :change_lbpark_permission do
    on roles(:all) do |host|
      execute "chmod a+x #{current_path}/config/lbpark.sh"
      #execute "chmod a+x #{current_path}/config/lb_resque.sh"
    end
  end
  after "deploy:published", "deploy:change_lbpark_permission"


  task :setup_config do
    on roles(:all) do |host|
      sudo "ln -nfs #{current_path}/config/mlbpark.conf /etc/nginx/sites-enabled/mlbpark"
      sudo "ln -nfs #{current_path}/config/lbpark.sh /etc/init.d/unicorn_lbpark"
      #sudo "ln -nfs #{current_path}/config/lb_resque.sh /etc/init.d/lb_resque"
    end
  end

  task :copy_kindeditor_assets do
    on roles(:all) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          execute :rake, "kindeditor:assets"
        end
      end
    end
  end

  after "deploy:published", "deploy:setup_config"
  after "deploy:published", "deploy:copy_kindeditor_assets"

end




