#!/bin/bash

source functions.sh

cd $HOME/www/crwd-tools || exit 1

echo ''

for pkg in php mcrypt memcached nginx psgrep
do
	message "brew install $pkg ..."
	brew install $pkg
	message ''
done

if [ -d /usr/local/etc/nginx ]
then
	true
else
	message 'something went terribly wrong!'
	exit 1
fi

if [ -d /usr/local/etc/nginx/sites-enabled ]
then
	true
else
	mkdir /usr/local/etc/nginx/sites-enabled
fi

if [ -f /usr/local/etc/nginx/nginx.conf.dist ]
then
	true
else
	cp /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf.dist
fi

cp conf/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf
gsed -i "s/REPLACE_ME/$USER/" conf/nginx/nginx.conf

mkdir -p /usr/local/var/log

message "nginx general error logs will be stored here: /usr/local/var/log/nginx.error.log"
message "if not, please read: /usr/local/etc/nginx/nginx.conf"

echo ''

if [ -f $HOME/bin/nginx.sh ]
then
	true
else
	ln -s scripts/nginx.sh $HOME/bin/nginx.sh
fi

[ "$(psgrep -a nginx | grep root)" ] && nginx.sh stop

nginx.sh start

echo ''
message 'done.'
echo ''