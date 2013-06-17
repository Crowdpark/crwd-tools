#!/bin/sh

daemon=php-fpm
executable=/usr/local/sbin/$daemon

case "$1" in
start)
   sudo $executable
   [ $? -eq 0 ] && echo "$daemon started..."
;;
stop)
   sudo killall $daemon
   [ $? -eq 0 ] && echo "$daemon stopped..."
;;
test)
   sudo $executable -t
   [ $? -eq 0 ] && echo "$daemon reloaded..."
;;
restart)
   $0 stop
   $0 start
;;
*)
   echo "Usage: $0 (start|stop|test|restart)"
;;
esac
