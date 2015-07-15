#!/usr/bin/python

# Append tag count to "None" owner field where tag count is 10 or more

import re
import sys
from os.path import expanduser

home = expanduser("~")
input = sys.argv[1]
output = sys.argv[2]

tagCounts = open(home + '/data/awsUtils/tagCounts.dat')
instanceOwnerIn = open(input)
instanceOwnerOut = open(output, 'w')

d = {}
for line in tagCounts:
   (key, val) = line.split()
   d[key] = val

for line in instanceOwnerIn:
    elements = line.split()
    if elements[6] == "None":
        if elements[0] in d.keys():
            instanceOwnerOut.write(line.rstrip('\n') + " - " + d[elements[0]] + " tags\n")
        else:
            instanceOwnerOut.write(line)
    else:
        instanceOwnerOut.write(line)

tagCounts.close()
instanceOwnerIn.close()
instanceOwnerOut.close()
