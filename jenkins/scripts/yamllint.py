#!/usr/bin/env python

import sys
import yaml

if len(sys.argv) < 2:
    print 'Missing file to lint'
    sys.exit(1)

i = 1
while i < len(sys.argv):
    try:
	yaml.load( open(sys.argv[i], 'r'), Loader=yaml.CLoader)
	print 'YAML: Syntax OK in file: '+ sys.argv[i]
    except:
	print "YAML: Invalid FAIL in file " + sys.argv[i]
    i+=1