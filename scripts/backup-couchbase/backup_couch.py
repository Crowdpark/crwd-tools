#! /usr/bin/python
import sys
import memcache
import json
import unicodedata
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f","--file",dest="filename",
		 help="Backup file to restore", metavar="FILE")
parser.add_option("-a","--address",dest="address",
		 help="Address of the host where the couchbase server is running")
parser.add_option("-o","--output",dest="output",
		 help="Path to output the file")

(options,args) = parser.parse_args()

if not options.filename:
	parser.error("Filename must be specified!")
if not options.address:
	parser.error("Host needs to be specified! e.g ip_address:port")
if not options.output:
	parser.error("Output path needs to be specified")


print('Connecting to couchbase...')
mc = memcache.Client([options.address])

print('Parsing backup data...')
json_data=open(options.filename)
data = json.load(json_data)

write_file = open("%s/full_backup" % options.output, "w")

print('Inserting data...')
count=0
second_count=1
yac=0
error_counter=0
for tuples in data['rows']:
	try:
		value = mc.get(tuples['id'].encode('ascii','ignore'))
        	tuples['values'] = unicode(value)
		count += 1
		if count == 10000:
			print ' Done with %s lines ' % (count*second_count)
			second_count += 1  
			count = 0
	except:
	    	error_counter += 1
		pass

print 'Number of errors: %s' % error_counter
write_file.write(json.dumps(data, sort_keys=True, indent=4))
write_file.close
