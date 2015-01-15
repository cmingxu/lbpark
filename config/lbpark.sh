#!/bin/sh
# rvm wrapper ruby-1.9.3-p194 bootup
UNICORN=/home/ubunut/.rvm/bin/bootup_unicorn
CONFIG_FILE=/home/ubunut/lbpark/current/config/unicorn.rb
APP_HOME=/home/ubunut/lbpark/current
 
case "$1" in
  start)
  $UNICORN -c $CONFIG_FILE -E production -D
  ;;
  stop)
  kill -QUIT `cat /tmp/unicorn_btcall.pid`
  ;;
  restart|force-reload)
    kill -USR2 `cat /tmp/unicorn_btcall.pid`
  ;;
  *)
   echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
   exit 3
   ;;
esac
 
:
