#!/usr/bin/env python

import sys
import yaml
import json

if len(sys.argv) < 2:
  print 'Missing file to transform'
  sys.exit(1)

data = yaml.load( open(sys.argv[1], 'r'), Loader=yaml.CLoader)
json = json.dumps(data)

print(json)
