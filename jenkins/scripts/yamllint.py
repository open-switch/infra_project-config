#!/usr/bin/env python

import sys
import yaml

if len(sys.argv) < 2:
  print 'Missing file to lint'
  sys.exit(1)

yaml.load( open(sys.argv[1], 'r'), Loader=yaml.CLoader)
print 'YAML syntax OK'
