cpFetch.sh
==========

cpFetch tries to read the project configuration to configure the local apache and other services to make it possible for non shell junkies to work on projects easier.

**Usage**

***Checkout***

	$ cpFetch checkout git@github.com:Crowdpark/processus.git

This will clone processus from github into "~/www/processus".

***Clean***

    $ cpFetch clean

Removes the temp folder from "~/www". This should be invoked after each successful checkout.

***Create***

create will setup a new project, do all git init stuff, creates a typically folder structure and adds Processus as a submodule to your new project.

There are two use cases:

****create and add the project**** automatically to a given github repo.

    $ cpFetch create PROJECT GITHUB-URL

or just create without adding the remote repo:

    $ cpFetch create PROJECT

Always try to follow the onscreen instructions.

***Create VHost (local Apache)***

    $ cpFetch createVhost PROJECT local.projectname.crowdpark.com
    
This will add 'local.projectname.crowdpark.com' to your hosts file (/private/etc/hosts) and create (if necessary) an apache config file which will be linked to /private/etc/apache2/sites. Apache will be restartet and the new site will be opened inside your Google Chrome browser.

**TODO list**

--- offer this as a brew recipe.

--- automated environment setup: mysql, etc...

**Warranty/Copyright (c) 2011 by [Crowdpark GmbH](http://www.crowdpark.com)**

Neither ... nor, nothing. You use this stuff at your own risk!
