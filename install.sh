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

