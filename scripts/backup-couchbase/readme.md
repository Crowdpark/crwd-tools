This scripts aim to successfully backup and restore information within the couchbase service

==========
Requisits
==========

In order to these scripts to work, a view must be created in the couchbase server. This view should list all the wanted keys to be back up, and the name of the view is assumed to be 'backup'.

Otherwise, please feel free to modify the code and replace the url.


==========
Install
==========

In order to use this scripts you will need to install the memcache and the couchbase library


==========
Usage
=========

-Backup
Just use the shell script backup_couchbase, this will generate a backup file with all the information provided from the view described above.

By default, the information will be sent to the S3 bucket under the path: s3://crowdpark-berlin-deploy/backups/

-Restore

To restore the backup, use the python script called restore_couch.py.

You will need to provide the file with the data, the address of the couchbase service (without specifying the port). Credentials needs to be introduced in the script prior its execution.

The restore script, uses by default the python couchbase client. If the client is not available, python memcache client can be used as well, there is some code already written which is commented in the script; use those comments as a reference - be careful python memcache client does not allow bucket routing.
