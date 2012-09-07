#!/bin/bash

MY_PATH="`dirname \"$0\"`"              # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized

if [ -z $1 ]; then
	echo "Ip address is required as a first argument / Second argument is optional (bucket)"
	exit
fi 

if [ -z $3 ]; then
	USERNAME="Administrator"
else
	PASSWORD="Administrator"
fi

if [ -z $4 ]; then
	USERNAME=$3
else
	PASSWORD=$4
fi

DATE=$(date +%Y%m%d%H%M)
COUNTER=0
mkdir /tmp/backup_couchbase


if [ -z $2 ]; then
	for i in `curl -u $USERNAME:$PASSWORD http://$1:8091/pools/default/buckets 2> /dev/null | python -mjson.tool | grep -v 'hostname' | grep 'name' | awk -F\" '{print \$4}'` ; do	
		echo "Backing up $i on $1"
		echo /usr/bin/curl "http://$1:8092/$i/_all_docs"
		/usr/bin/curl "http://$1:8092/$i/_all_docs" > /tmp/backup_tmp
		wc -l /tmp/backup_tmp 
		python $MY_PATH/backup_memc.py -a $1:8091 -b $i -f /tmp/backup_tmp -o /tmp/backup_couchbase/backup_$i -u ${USERNAME} -p ${PASSWORD} 
	done
else
	echo "Backing up $2"
        /usr/bin/curl 'http://$1:8092/$2/_all_docs' > /tmp/backup_tmp
        python $MY_PATH/backup_memc.py -a $1:8091 -b $2 -f /tmp/backup_tmp -o /tmp/backup_couchbase/backup_$2  -u ${USERNAME} -p ${PASSWORD}
fi


#packaging data
tar cfz /tmp/backup_$DATE.tar.gz /tmp/backup_couchbase/

#Example s3cmd
#s3cmd put /tmp/backup_$DATE.tar.gz s3://crowdpark-berlin-deploy/backups/backup_couchbase_$DATE

#cleaning up
rm -rf /tmp/backup_couchbase
rm /tmp/backup_tmp

#Done
echo 'Backup done'
