This scripts aim to successfully backup and restore information within the couchbase service

==========
Description
==========

These scripts work together to backup and restore all keys in a couchbase database. There are two kind of scripts, one of them is meant for big db with a lot of keys (~400k) the other one is meant for small - development type of db with fewer keys.

==========
Install
==========

These scripts are based in python and bash. So both are a initial requirement.

Couchbase library and memcache library are required to run those scripts ( Couchbase for the restore procedure and memcache for the backup)


To install them, once you have  python and pip - just run "easy_install memcache (or) couchbase" 


==========
Usage
=========

-Backup
Just use the shell script backup_couchbase, this will generate a backup file with all the information provided from the view described above.

By default,the backup will be stored in /tmp 

-Restore

To restore the backup, use the python script called restore_couch.py.

You will need to provide the file with the data, the address of the couchbase service (without specifying the port). Credentials needs to be introduced in the script prior its execution.

The restore script, uses by default the python couchbase client. If the client is not available, python memcache client can be used as well, there is some code already written which is commented in the script; use those comments as a reference - be careful python memcache client does not allow bucket routing.
