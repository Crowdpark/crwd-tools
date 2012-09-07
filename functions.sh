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
