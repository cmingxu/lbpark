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
      execute "cd /home/ubuntu/lbpark/current && COUNT=2 RAILS_ENV=production PIDFILE=/home/ubuntu/lbpark/shared/tmp/pids/resque.pid BACKGROUND=yes QUEUE=* bundle exec rake resque:work"
      execute "cd /home/ubuntu/lbpark/current && RESQUE_SCHEDULER_INTERVAL=1  LOGFILE=/home/ubuntu/lbpark/shared/log/resque_scheduler.log  RAILS_ENV=production PIDFILE=/home/ubuntu/lbpark/shared/tmp/pids/resque_scheduler.pid BACKGROUND=yes bundle exec rake resque:scheduler"
      #execute "/home/ubuntu/lbpark/current/bin/res start"
    end
  end

  desc "stop unicorn server"
  task :stop do
    on roles(:all) do |host|
      execute "/etc/init.d/unicorn_lbpark stop"
      execute "kill -QUIT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque.pid`"
      execute "kill -QUIT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque_scheduler.pid`"
    end
  end

  desc "restart unicorn server"
  task :restart do
    on roles(:all) do |host|
      execute "/etc/init.d/unicorn_lbpark restart"
    end
  end
end
