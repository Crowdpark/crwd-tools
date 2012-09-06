#!/bin/sh

case "$1" in
start)
   open -a 'Couchbase Server'
   [ $? -eq 0 ] && echo "'Couchbase Server' started..."
;;
stop)
   killall -1 'Couchbase Server'
   [ $? -eq 0 ] && echo "'Couchbase Server' stopped..."
;;
restart)
   $0 stop
   sleep 2
   $0 start
;;
*)
   echo "Usage: $0 (start|stop|restart)"
;;
esac
