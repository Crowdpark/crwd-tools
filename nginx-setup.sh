#!/bin/bash

source functions.sh

cd $HOME/www/crwd-tools || exit 1

echo ''

brew tap josegonzalez/homebrew-php
brew tap homebrew/dupes
brew install --without-apache --with-suhosin --with-fpm --with-mysql php53

for pkg in git mcrypt memcached nginx psgrep
do
	message "brew install $pkg ..."
	brew install $pkg
	message ''
done

if [ -d /usr/local/etc/nginx ]
then
	true
else
	error 'something went terribly wrong! Could not find nginx...'
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

gsed -i "s/REPLACE_ME/$USER/" conf/nginx/nginx.conf
cp conf/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

find /usr/local/etc -name php\*fpm.conf -exec gsed -i 's/daemonize.*/daemonize = yes ; defaul is no/' {} \;

mkdir -p /usr/local/var/run
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