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

if [ -d ~/bin ]
	then
		true
	else
		mkdir ~/bin
fi

echo '
# ---- crwd-tools ----
LANG="en_US.UTF-8"
export LANG
LC_ALL="en_US.UTF-8"
export LC_ALL
LC_CTYPE="UTF-8"
export LC_CTYPE

PATH=~/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH
# ----
' >> ~/.profile
