#!/bin/bash
#
#

# GLOBALS (yeah no real... but...)

TODO=$1
REPO=''
PDIR="$HOME/www"
TDIR="$PDIR/tmp"
TEMP="$TDIR/$(date +%Y%m%d%H%M%S)"
VHOST='localhost'
PROJECT=''

# FUNCTIONS

function error ()
{
	echo ''
	echo $'\e[31m''---- EXIT BY ERROR: '
	echo $'\e[31m'$1
	echo ''
	tput sgr0 
	exit
}

function checkout ()
{
	message "...on my way for: $REPO"

	mkdir -p $TEMP || error 'could not create TEMP'

	cd $TEMP

	git clone --recurse-submodules $REPO || error 'git clone failed!'

	PROJECT=$(ls -1 $TEMP)

	message "temp. project folder = $PROJECT"

	if [ -d $PDIR'/'$PROJECT ]
		then error 'The project still exists on your drive. Please remove the project before!'
	fi

	mv "$TEMP/$PROJECT" "$PDIR/$PROJECT"

	cd "$PDIR/$PROJECT"

	git branch dev-anonymous
	git commit -am 'switch to dev-anonymous'
	git pull origin dev-anonymous
	git commit -am 'switch to dev-anonymous'
	git push origin dev-anonymous
}

function message ()
{
	echo $'\e[32m'$1
	tput sgr0
}

function success ()
{
	echo $'\e[33m'"
The project was checked out into "$PDIR/$PROJECT".

To avoid conflicts the main project was branched to origin dev-anonymous.

You have to create you own branch:

  $ git checkout -b dev-YOURNAME
  $ git commit -am 'Initial Commit'
  $ git push origin dev-YOURNAME

It is mandatory that all of your commits are done against your own branch.

It is also mandatory that you merge from dev-francis or master to pull
latest changes.

There is a possibility that a submodule was checked out also. Please do not
make any changes to the submodule as long as your not told to do so. If in
doubt ask your project lead.

Have fun!

Alexander <alexander.finger@crowdpark.com>
"
	tput sgr0
}

function create ()
{
    message "create called for project: '$PROJECT'"

    if [ -d "$PDIR/$PROJECT" ]
        then error 'are you kidding me? The project already exists!'
    fi

    mkdir -p "$PDIR/$PROJECT" || error 'mkdir failed! check ~/www for proper rw permissions'

    cd "$PDIR/$PROJECT"

    git init
    touch README.md

    for newdir in \
        application \
        application/coffeescript \
        application/doc \
        application/less \
        application/nginx.config \
        application/apache.config \
        application/php/Application \
        application/sql \
        bin \
        build \
        htdocs
        do mkdir -p "$newdir" && touch "$newdir/.keep"
    done

    git submodule add git@github.com:Crowdpark/processus.git library/Processus

    cp -rp library/Processus/build/example/project/* .

    ls -1 | grep -v library | xargs git add

    git commit -am "automated init for $PROJECT by local user $USER"

    if [ "$REPO" == "" ]
        then howtoRepoAdd
        else
            git remote add origin $REPO
            git branch cpFetch
            git commit -am 'cpFetch init'
            git push origin cpFetch
            message ''
            message '---------------------------------------------------------------------'
            message 'Please make sure that you create as soon as'
            message 'possible a master branch or merge your project into the master branch'
            message '---------------------------------------------------------------------'
    fi
}

function createVhost ()
{
    if [ -f /usr/local/bin/brew ]
        then
            if [ -f /usr/local/bin/gsed ]
                then true
                else 
                    brew update
                    brew install gnu-sed
            fi
        else error 'EPIC FAIL: no brew installed!'
    fi

    if [ -n "$VHOST" ]
        then true
        else error 'no vhost given! cpFetch PROJECT VHOST'
    fi

    message "create vhost called for project: '$PROJECT'"

    if [ -d "$PDIR/$PROJECT" ]
        then true
        else error 'are you kidding me? The project does NOT exist!'
    fi

    if [ -d "$PDIR/$PROJECT/htdocs" ]
        then true
        else mkdir -p "$PDIR/$PROJECT/htdocs" || error 'mkdir failed! check ~/www and the project folders for proper rw permissions'
    fi

    if [ -d "$PDIR/$PROJECT/application/apache.config" ]
        then true
        else mkdir -p "$PDIR/$PROJECT/application/apache.config" || error 'mkdir failed! check ~/www and the project folders for proper rw permissions'
    fi

    message ""
    message "Now we need your Admin/Root password for this computer:"
    message ""
    sudo cp /private/etc/hosts /private/etc/hosts.bak

    if [ $(grep -c $VHOST /private/etc/hosts) == 0 ]
        then
        sudo chmod 666 /private/etc/hosts
        sudo echo '' >> /private/etc/hosts
        sudo echo '# additions made by Crowdpark/cpFetch' >> /private/etc/hosts
        sudo echo '' >> /private/etc/hosts
        sudo echo "127.0.0.1 $VHOST" >> /private/etc/hosts
        sudo echo "::1 $VHOST" >> /private/etc/hosts
        sudo chmod 644 /private/etc/hosts
    fi

    cd "$PDIR/$PROJECT"

    vhostConfigFile="$PDIR/$PROJECT/application/apache.config/$VHOST.osx.conf"
    vhostConfig="
<VirtualHost *:80>
    ServerName      $VHOST
    DocumentRoot    $PDIR/$PROJECT/htdocs
    DirectoryIndex  index.php

    <Directory "$PDIR/$PROJECT/htdocs">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>"

    if [ -f $vhostConfigFile ]
        then
            message "vhostConfigFile $vhostConfigFile already exists!"
            message 'Please copy and change it to your local settings and link it into /private/etc/apache2/sites'
            message 'Example:'
            message 'sudo ln -sf YOUR_CONFIG /private/etc/apache2/sites/PROJECTNAME.config'
        else
            echo "$vhostConfig" > $vhostConfigFile
            sudo ln -sf $vhostConfigFile /private/etc/apache2/sites/$VHOST.conf
    fi

    
    sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
    sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
    sleep 2

    message ''
    message '----------------------------------------------------------------------------------'
    message ''
    message "VHOST http://$VHOST is now setup and you can use your webbrowser"
    open -F -a 'Google Chrome' "http://$VHOST"

    message "depending on your current project, it might be necessary to launch Couchbase, MySQL or other services too."
    message ''
    message '----------------------------------------------------------------------------------'
    message "DONE."
}

function howtoRepoAdd ()
{
    message ''
    message '----------------------------------------------------------------------------------'
    message 'The link below explains how to add an existing repo to a github repo.'
    message '"http://stackoverflow.com/questions/4658606/import-existing-source-code-to-github"'
    message '----------------------------------------------------------------------------------'
}

# MAIN

echo ''

case $1 in
    create)
        PROJECT=$2
        REPO=$3
        create
        ;;
    createVhost)
        PROJECT=$2
        VHOST=$3
        createVhost
        ;;
	checkout)
	    REPO=$2
		checkout
		success
		;;
	clean)
		message "remove $TDIR and all of its contents..."
		rm -rf $TDIR
		;;
	*)
		echo 'Usage: cpFecth [clean|checkout URL|create PROJECTNAME [URL]|createVhost PROJECTNAME VHOST]'
		;;
esac

echo ''
echo $'\e[32m''done.'
tput sgr0 

exit
# EOF
