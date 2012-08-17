#!/bin/bash

for D in $( find ~/www -name apache.config -type d )
do
	echo "looking for apache configs in: $D"
	for C in $( find $D -type f -name \*conf )
	do
		echo -n "found $C ..."
		if sudo ln -s $C /private/etc/apache2/sites/ > /dev/null 2>&1
			then
				echo "linked succesfully"
			else
				echo "link failed! Please check why."
		fi
	done
	echo ''
done

sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist

#EOF