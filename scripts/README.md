cpUtil.sh (before known as cpUtil.sh)
======================================

cpUtil.sh tries to read the project configuration to configure the local apache and other services to make it possible for non shell junkies to work on projects easier.

**Usage**

***Checkout***

	$ cpUtil.sh checkout git@github.com:Crowdpark/processus.git

This will clone processus from github into "~/www/processus".

***Clean***

    $ cpUtil.sh clean

Removes the temp folder from "~/www". This should be invoked after each successful checkout.

***Create***

create will setup a new project, do all git init stuff, creates a typically folder structure and adds Processus as a submodule to your new project.

There are two use cases:

****create and add the project**** automatically to a given github repo.

    $ cpUtil.sh create PROJECT GITHUB-URL

or just create without adding the remote repo:

    $ cpUtil.sh create PROJECT

Always try to follow the onscreen instructions.

***Create VHost (local Apache or local Nginx)***

    $ cpUtil.sh createVhost PROJECT local.projectname.crowdpark.com
    
After calling cpUtil with these parameters you will be asked if the new vhost will be added for apache or nginx.

This will add 'local.projectname.crowdpark.com' to your hosts file (/private/etc/hosts) and create (if necessary) an apache config file which will be linked to /private/etc/apache2/sites. Apache will be restartet and the new site will be opened inside your Google Chrome browser.

**TODO list**

--------

updateApacheVhosts.sh
=====================

This script tries to update your local apache vhosts. It fetches all vhost config files from your projects and creates symlinks into the apache sites folder.

Afterwards the local apache will be restarted, so please be prepared to enter your password (for sudo).

--------

**Warranty/Copyright (c) 2011 by [Crowdpark GmbH](http://www.crowdpark.com)**

Neither ... nor, nothing. You use this stuff at your own risk!
