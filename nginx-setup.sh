#!/bin/bash

cd $HOME/www/crwd-tools || exit 1

echo ''

for pkg in php mcrypt memcached nginx beanstalk
do
	echo "brew install $pkg ..."
	brew install $pkg
	echo ''
done

if [ -d /usr/local/etc/nginx ]
then
	true
else
	echo 'something went terribly wrong!'
	exit 1
fi

mkdir /usr/local/etc/nginx/sites-enabled

if [ -f /usr/local/etc/nginx/nginx.conf.dist ]
then
	true
else
	cp /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf.dist
fi

cp conf/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

mkdir -p /usr/local/var/log