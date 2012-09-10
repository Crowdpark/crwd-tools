#!/bin/bash

source functions.sh

if [ -f /usr/local/bin/brew ]
	then
		true
	else
		message "setup install brew"
		if [ -f "$(which gcc)" ]
			then
				ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
			else
				error "Without 'Developer Comand Line Tools' no fun!"
		fi
		
fi

for pkg in gnu-sed \
           beanstalkd \
           redis \
           mysql
do
	brew install $pkg && message "installed $pkg via brew."
done

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

echo ''
message 'just make sure this repo is updated...'
git pull origin master
git submodule init
git submodule update
message 'crwd-tools are fine...'
echo ''

if [ -d $HOME/bin ]
	then
		true
	else
		mkdir $HOME/bin
fi

message 'symlinks into $HOME/bin will be created now.'

for i in $(ls -1 scripts | grep -i \.sh)
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
message 'crwd-tools setup/update done.'
echo ''

promptContinue 'continue with individual setup scripts like nginx and others? (N|y)'

echo ''
message 'nginx setup...'
./nginx-setup.sh



#EOF