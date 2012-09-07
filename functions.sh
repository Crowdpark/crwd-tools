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

promptContinue()
{
	read -p "$1" -n 1

	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo ""
	    exit
	fi
}

promptStop()
{
	read -p "$1" -n 1

	if [[ $REPLY =~ ^[Nn]$ ]]
	then
		echo ""
	    exit
	fi
}