#! /usr/bin/python

#import memcache
from couchbase import Couchbase
import json,os
import unicodedata
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f","--file",dest="filename",
		 help="Backup file to restore", metavar="FILE")
parser.add_option("-p","--path",dest="path",
		 help="Path where backup files are")
parser.add_option("-a","--address",dest="address",
		 help="IP address of the service")
parser.add_option("-b","--bucket",dest="bucket",
		 help="Bucket to restore")

(options,args) = parser.parse_args()

if  not options.filename:
	if  not options.path:
		parser.error("Either a filename or a path must be specified")
if  not options.address:
	parser.error("Address must be specified!")

if options.filename:
	list_filename=[os.path.basename(options.filename)]
	path=os.path.dirname(options.filename)
else:
	list_filename=os.listdir(options.path)
	path=options.path


print('Connecting to couchbase...')
mc = Couchbase(options.address,"Administrator","Administrator")

if options.bucket:
	bucket=mc[options.bucket]
else:
	bucket=mc["default"]


f = open('/tmp/debug','w')

for filename in list_filename:
	print('Parsing backup data... from %s' % filename)
	json_data=open(path+'/'+filename)

	data = json.load(json_data)

	print('Inserting data...')
	count=0
	error_counter=0
	second_count=1
	for tuple in data['rows']:
		try:
			test = tuple['value'].encode('ascii','ignore')
		except e,Exception:
			test = 0
			print 'real issue'
			pass
		try:
			bucket.set(tuple['id'].encode('ascii','ignore'),86400,0,tuple['value'].encode('ascii','ignore'))
		except BaseException, e:
		    	print e
			if  test==0 :
				print "another issue"
				print tuple['value']	
			f.write( 'counter: %s id: %s value: %s \n' %  (count,tuple['id'],tuple['value'])) 
			error_counter += 1
			pass
		count += 1
		if count == 10000:
			print ' Done with %s lines ' % (count*second_count)
			second_count += 1  
			count = 0
f.close()
print "Done!"	
