#!/bin/sh


case "$1" in
  start)
    su ubuntu -c rvm use 2.1.5 && cd /home/ubuntu/lbpark/current && COUNT=2 RAILS_ENV=production PIDFILE=/home/ubuntu/lbpark/shared/tmp/pids/resque.pid BACKGROUND=yes QUEUE=* bundle exec rake resque:work
    cd /home/ubuntu/lbpark/current && RAILS_ENV=production PIDFILE=/home/ubuntu/lbpark/shared/tmp/pids/resque_scheduler.pid BACKGROUND=yes bundle exec rake resque:scheduler
  ;;
  stop)
    kill -QUIT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque.pid`
    kill -QUIT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque_scheduler.pid`
    sleep 3
    kill -INT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque.pid` > /dev/null  2>&1
    kill -INT `cat /home/ubuntu/lbpark/shared/tmp/pids/resque_scheduler.pid` > /dev/null 2 >&1
  ;;
  *)
   echo "Usage: $SCRIPTNAME {start|stop}" >&2
   exit 3
   ;;
esac
:

