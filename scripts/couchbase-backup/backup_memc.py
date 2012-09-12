#! /usr/bin/python
import sys,time
from couchbase import Couchbase
import json
import unicodedata
from optparse import OptionParser
#from unidecode import unidecode
#from guppy import hpy
#h = hpy()
#print h.heap()


def main():
	parser = OptionParser()
	parser.add_option("-f","--file",dest="filename",
			 help="Backup file to restore", metavar="FILE")
	parser.add_option("-a","--address",dest="address",
			 help="Address of the host where the couchbase server is running")
	parser.add_option("-o","--output",dest="output",
			 help="Path to output the file")
	parser.add_option("-b","--bucket",dest="bucket",
			 help="Path to output the file")
	parser.add_option("-u","--username",dest="username",
			 help="couchbase username")
	parser.add_option("-p","--password",dest="password",
			 help="couchbase password")

	(options,args) = parser.parse_args()
	
	if not options.filename:
		parser.error("Filename must be specified!")
	if not options.address:
		parser.error("Host needs to be specified! e.g ip_address:port")
	if not options.output:
		parser.error("Output path needs to be specified")
	if not options.bucket:
		parser.error("Bucket needs to be specified")
	if not options.username:
		parser.error("Couchbase username needs to be specified")
	if not options.password:
		parser.error("Couchbase password needs to be specified")

	bc=connect(options)
	data=parse(options.filename)
	process(bc,data,options.output)
	
	print 'Done'

def connect(options):
	print('Connecting to couchbase...')
	mc = Couchbase(options.address,options.username,options.password)

	print('Selecting bucket %s' % options.bucket)
	bc = mc[options.bucket]
	return bc

def parse(filename):
	print('Parsing backup data from... %s' % filename)
	json_data=open(filename)
	data = json.load(json_data)
	return data

def process(bc,data,output):

	print('Inserting data...')
	error_counter=0

	iterations = data['total_rows'] / 10000 + 1
	
	for i in range(0,iterations):

		write_file = open(output+str(i), "w")
		chunk_data=data['rows'][i*10000:i*10000+10000]		

		for tuples in chunk_data:
			try:
				value = bc.get(tuples['id'].encode('ascii','ignore'))
				tuples['value'] = value[2].encode('ascii','ignore')
			except:
				tuples['value'] = ''
				error_counter += 1
				pass
	
		write_file.write(json.dumps(chunk_data, indent=4))
		write_file.close
		print("Done with %s lines" % (i*10000 + 10000))
		print ("Sleeping 10 seconds")

		#h = hpy()
		#print h.heap()

	print 'Number of errors: %s' % error_counter

if __name__ == "__main__":
    main()
