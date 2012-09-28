crwd-tools (formerly known as bash-pm)
----

Every Developer at Crowdpark just need a github account and the github project url to fetch the project. Also cpFetch tries to read the project configuration to configure the local apache and other services to make it possible for non shell junkies to work on projects easier.

**Requirements**
----

[Mac OSX Commandline Tools](developer.apple.com)

**Install & Setup**
----

	curl https://raw.github.com/Crowdpark/crwd-tools/master/install.sh | sh

If not already created, this will create the std. project folder www in your home directory and then clones the crwd-tools into your project folder. Afterwards the local setup will be done.

**Usage**
----

There are several tools. Please read the individual ReadMe files.

**Some Info**
----
If you don't know about your system I'll try to give you some entry points:

**1.) [brew - homebrew](https://github.com/mxcl/homebrew)**

Brew is a package managar which provides the most easy and elegant way (at the moment) to install *NIX packages on OSX.

**2.) Nginx & php-fpm**

Nginx and php-fpm (php in general) configs can be found in /usr/local/etc, if you use the brew versions (which I would strongly recommend).

**3.) Crowdpark Projects**

Crowdpark projects has to be placed in ~/www/projectname, ~ is the common shortcut for the path to your homedir, you can also use $HOME. Try out 'ls -la $HOME', 'ls -la ~' or 'cd ~; pwd'

----

**Copyright (c) 2012 by [Crowdpark GmbH](http://www.crowdpark.com)**

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
