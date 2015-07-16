#!/usr/bin/python

# Append tag count to "None" owner field where tag count is 10 or more

import re
import sys
import smtplib
import ConfigParser

from os.path import expanduser
from email.mime.text import MIMEText

home = expanduser("~")
input = sys.argv[1]
output = sys.argv[2]

tagCounts = open(home + '/data/awsUtils/tagCounts.dat')
instanceOwnerIn = open(input)
instanceOwnerOut = open(output, 'w')

config = ConfigParser.ConfigParser()
config.read(home + '/data/ownerTags/ownerTags.cfg')

d = {}
for line in tagCounts:
   (key, val) = line.split()
   d[key] = val

for line in instanceOwnerIn:
    elements = line.split()

    try:
        if elements[6] == "None":
            if elements[0] in d.keys():
                instanceOwnerOut.write(line.rstrip('\n') + " - " + d[elements[0]] + " tags\n")
            else:
                instanceOwnerOut.write(line)
        else:
            instanceOwnerOut.write(line)
    except IndexError:
        emailFrom = config.get("OwnerTags", "EmailFrom")
        emailTo = config.get("OwnerTags", "EmailTo")
        msg = MIMEText("IndexError on: " + elements[0] + " from addExceededTagCounts.py")
        msg['Subject'] = "IndexError on: " + elements[0] + " from addExceededTagCounts.py"
        msg['From'] = emailFrom
        msg['To'] = emailTo
        s = smtplib.SMTP('localhost')
        s.sendmail(emailFrom, [emailTo], msg.as_string())
        s.quit()

tagCounts.close()
instanceOwnerIn.close()
instanceOwnerOut.close()
