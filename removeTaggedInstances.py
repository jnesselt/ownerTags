#!/usr/bin/python

# Remove instances that have owner tag

import re
import sys
import smtplib
import ConfigParser

from os.path import expanduser
from email.mime.text import MIMEText

home = expanduser("~")
input = sys.argv[1]
output = sys.argv[2]
environment = sys.argv[3]
region = sys.argv[4]

instanceOwnerIn = open(input)
instanceOwnerOut = open(output, 'w')

config = ConfigParser.ConfigParser()
config.read(home + '/data/ownerTags/ownerTags.cfg')

for line in instanceOwnerIn:
    line = line.rstrip("\n")
    elements = line.split("\t")

    if elements[0] == "InstanceId":
        instanceOwnerOut.write(line + "\n")
    else:
        try:
            if elements[6] == "None":
                instanceOwnerOut.write(line + "\n")
            #else:
            #    sys.stdout.write(line + "\n")
        except IndexError:
            emailFrom = config.get("OwnerTags", "EmailFrom")
            emailTo = config.get("OwnerTags", "EmailTo")
            msg = MIMEText("IndexError on: " + elements[0] + " from addExceededTagCounts.py" + "\nEnvironment: " + environment + "\nRegion: " + region)
            msg['Subject'] = "IndexError on: " + elements[0] + " from addExceededTagCounts.py"
            msg['From'] = emailFrom
            msg['To'] = emailTo
            s = smtplib.SMTP('localhost')
            s.sendmail(emailFrom, [emailTo], msg.as_string())
            s.quit()

instanceOwnerIn.close()
instanceOwnerOut.close()
