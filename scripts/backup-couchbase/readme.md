This scripts aim to successfully backup and restore information within the couchbase service


==========
Install
==========

These scripts are based in python and bash. So both are a initial requirement.
Couchbase library is also required to run those scripts. To install it just run "easy_install couchbase" 

==========
Usage
=========

-Backup

run backup_couchbase <ip_addr> [<bucket>]

Ip address is a mandatory field.
Bucket is not, if no bucket is specified, the script will back up all the buckets in the system

By default, the information will be stored under /tmp

-Restore

To restore the backup, use the python script called restore_couch.py.

You will need to provide the file with the data or the path where the files are located and the address of the couchbase service (without specifying the port).



