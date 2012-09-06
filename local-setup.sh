#!/bin/bash

function error ()
{
	echo ''
	echo $'\e[31m''---- EXIT BY ERROR: '
	echo $'\e[31m'$1
	echo ''
	tput sgr0 
	exit
}

function message ()
{
	echo $'\e[32m'$1
	tput sgr0
}

if [ -f /usr/local/bin/brew ]
	then
		true
	else
		error "Install brew first!"
fi

brew install gnu-sed

if [ -d scripts ]
	then
		true
	else
		cd $HOME/www/crwd-tools
fi

if [ -d scripts ]
	then
		true
	else
		error "Can't cd into crwd-tools. We assume you run a crowdpark setup which means ALL projects are located in $HOME/www/"
fi

if [ -d $HOME/bin ]
	then
		true
	else
		mkdir $HOME/bin
fi

message 'symlinks into $HOME/bin will be created now.'

for i in $(ls -1 scripts | grep -vi readme)
do
	ln -s $(pwd)/scripts/$i $HOME/bin/$i
done

if grep crwd-tools $HOME/.profile > /dev/null 2>&1
	then
		message '$HOME/.profile is already up to date. Please verify later manually.'
	else
		echo '
# ---- crwd-tools ----
LANG="en_US.UTF-8"
export LANG
LC_ALL="en_US.UTF-8"
export LC_ALL
LC_CTYPE="UTF-8"
export LC_CTYPE

PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH
# ----
' >> $HOME/.profile
		message 'Added crwd-tools section to $HOME/.profile'
fi

echo ''
message 'crwd-tools setup done.'
echo ''

#EOF