!#/bin/bash

read -p "This script will setup crwd-tools on your mac(!), continue? (N|y)" -n 1

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "crwd-tools setup aborted."
    exit 1
fi

if [ -d $HOME/www ]
else
	mkdir $HOME/www
fi

if [ -d $HOME/www/crwd-tools ]
then
	echo "crwd-tools are already installed... chdir into $HOME/www/crwd-tools and run 'git pull origin master' to update."
	exit 1
fi

cd $HOME/www

git clone --recursive https://github.com/Crowdpark/crwd-tools crwd-tools && cd crwd-tools && ./local-setup.sh

echo "done."

#EOF