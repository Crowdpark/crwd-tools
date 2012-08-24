This scripts aim to successfully backup and restore information within the couchbase service


==========
Install
==========

These scripts are based in python and bash. So both are a initial requirement.

Couchbase library is also required to run those scripts. To install them, once you have  python and pip - just run "easy_install memcache (or) couchbase" 


==========
Usage
=========

Both scripts have hardcoded credentials, please change them prior to execution

-Backup
Just use the shell script backup_couchbase indicating the ip address (i.e ./backup_couchbase <ip_address> ) 

By default, the information will be stored in /tmp

-Restore

To restore the backup, use the python script called restore_couch.py.

You will need to provide the file with the data (or the path where the files can be found), the address of the couchbase service (without specifying the port).



