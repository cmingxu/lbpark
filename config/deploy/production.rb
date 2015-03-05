# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{ubuntu@119.254.101.147}
role :web, %w{ubuntu@119.254.101.147}
role :db,  %w{ubuntu@119.254.101.147}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '119.254.101.147', user: 'ubuntu', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
  user: 'ubuntu',
  forward_agent: true,
  keys: %w(/Users/cmingxu/.ssh/kp-kvakeu87)
}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
#
namespace :deploy do
  desc "start unicorn server"
  task :start do
    on roles(:all) do |host|
      execute "/etc/init.d/unicorn_lbpark start"
    end
  end

  desc "stop unicorn server"
  task :stop do
    on roles(:all) do |host|
      execute "/etc/init.d/unicorn_lbpark stop"
    end
  end

  desc "restart unicorn server"
  task :restart do
    on roles(:all) do |host|
      execute "/etc/init.d/unicorn_lbpark restart"
    end
  end
end

set :resque_pid_file, ''
namespace :deploy do
  def remote_process_exist(pidfile_path)
    if Numeric === pidfile_path
      test("kill -0 #{pidfile_path}")
    else
      test("[ -f #{pidfile_path} ]") && test("kill -0 `cat #{pidfile_path}`")
    end
  end

  desc "start both resque and resque_scheduler"
  task :resque_start do
    on roles(:all) do |host|
      within current_path do
        with :RESQUE_TERM_TIMEOUT =>1, :TERM_CHILD=>1, :count => 2, :rails_env => fetch(:rails_env), :pidfile => "#{shared_path}/tmp/pids/resque.pid", :background => "yes", :queue => "*" do
          execute :rake, "resque:work  >/dev/null 2>&1 &"
        end

        with :resque_scheduler_interval => 1, :rails_env => fetch(:rails_env),
          :pidfile => "#{shared_path}/tmp/pids/resque_scheduler.pid", :background => true,
          :logfile => "#{shared_path}/log/resque_scheduler.log"  do
          execute :rake, "resque:scheduler  >/dev/null 2>&1 &"
        end
      end
    end
  end

  task :resque_stop do
    on roles(:all) do |host|
      if remote_process_exist("#{shared_path}/tmp/pids/resque.pid")
        pid = capture("cat #{shared_path}/tmp/pids/resque.pid")
        execute :kill, "-TERM  #{pid}"
      end

      if remote_process_exist("#{shared_path}/tmp/pids/resque_scheduler.pid")
        pid = capture("cat #{shared_path}/tmp/pids/resque_scheduler.pid")
        execute :kill, "-9  #{pid}"
      end
    end
  end

  task :resque_restart do
    Rake::Task["deploy:resque_stop"].invoke
    Rake::Task["deploy:resque_start"].invoke
  end

end
after "deploy:start", "deploy:resque_start"
after "deploy:stop", "deploy:resque_stop"
after "deploy:restart", "deploy:resque_restart"


