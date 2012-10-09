#!/bin/bash
#
#

CURDATE=$(date +%Y%m%d%H%M%S)
echo $CURDATE

FILENAME="backup_$CURDATE.json"
echo $FILENAME

curl "http://ec2-79-125-38-103.eu-west-1.compute.amazonaws.com:8092/default/_design/system/_view/backup?connection_timeout=60000&skip=0&include_docs=true" > $FILENAME