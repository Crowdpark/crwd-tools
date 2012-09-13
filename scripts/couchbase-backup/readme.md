couchbase-backup
================

	"Always two there are, no more, no less. A master and an apprentice."

All 2.0 Couchbase versions prior build 1672 have broken backup and restore scripts.

These scripts does not work with any verions prior 2.0!

*backup.php*

	$ php backup.php -h HOSTNAME -b BUCKETNAME -d DESTINATION DIR

DESTINATION DIR will always be created in /tmp

TODO: after backup the destination should be packed as tar.gz and then (optional) transfrerred to a given S3 location.

*restore.php*

	$ php restore.php -h HOSTNAME -p PORT -d BACKUP DIR

BACKUP DIR must be the full path to the directory which contains the single json files.
