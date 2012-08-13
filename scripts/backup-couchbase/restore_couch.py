#! /usr/bin/python

#import memcache
from couchbase import Couchbase
import json
import unicodedata
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f","--file",dest="filename",
		 help="Backup file to restore", metavar="FILE")
parser.add_option("-a","--address",dest="address",
		 help="IP address of the service")
parser.add_option("-b","--bucket",dest="bucket",
		 help="Bucket to restore")

(options,args) = parser.parse_args()

if  not options.filename:
	parser.error("Filename must be specified!")
if  not options.address:
	parser.error("Address must be specified!")


print('Connecting to couchbase...')
#mc = memcache.Client(['ec2-54-247-28-110.eu-west-1.compute.amazonaws.com:11211'])
mc = Couchbase(options.address+":8091","Administrator","Administrator")

if options.bucket:
	bucket=mc[options.bucket]
else
	bucket=mc["default"]

print('Parsing backup data...')
json_data=open(options.filename)
data = json.load(json_data)

print('Inserting data...')
count=0
second_count=1
for tuple in data['rows']:
	bucket.set(tuple['id'].encode('ascii','ignore'),0,0,tuple['key'].encode('ascii','ignore'))
	count += 1
	if count == 10000:
		print ' Done with %s lines ' % (count*second_count)
		second_count += 1  
		count = 0

