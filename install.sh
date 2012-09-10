#!/bin/bash

echo ''
echo '---- setup crwd-tools'
echo 'This script will setup crwd-tools on your mac(!), if you want to abort this press CTRL-C ... the script continues in 5 sec.'

sleep 5

if [ -d $HOME/www ]
then
	true
else
	mkdir $HOME/www
fi

if [ -d $HOME/www/crwd-tools ]
then
	echo ''
	echo "crwd-tools are already installed... chdir into $HOME/www/crwd-tools and run 'git pull origin master' for update."
	exit 1
fi

cd $HOME/www

git clone --recursive https://github.com/Crowdpark/crwd-tools crwd-tools && cd crwd-tools && ./local-setup.sh

echo ''
echo "done."

#EOF