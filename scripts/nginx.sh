#!/bin/sh

daemon=nginx
executable=/usr/local/bin/$daemon

case "$1" in
start)
   sudo $executable
   [ $? -eq 0 ] && echo "$daemon started..."
;;
stop)
   sudo $executable -s stop
   [ $? -eq 0 ] && echo "$daemon stopped..."
;;
reload)
   sudo $executable -s reload
   [ $? -eq 0 ] && echo "$daemon reloaded..."
;;
restart)
   $0 stop
   $0 start
;;
*)
   echo "Usage: $0 (start|stop|restart)"
;;
esac
