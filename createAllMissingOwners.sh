#!/bin/bash

# Print out untagged owner instances for a specific date using system and key name mapping files.
# For all Accounts / Regions.
# Format for instanceId files.

usage_func() {
    echo 
    echo "Usage: "`basename $0`" [date (YYYY-MM-DD)]"
    echo 
    echo "example: " `basename $0` "2015-03-30"
    echo 
    exit 1
}

mydate=$1

if [ "$mydate" = "" ]; then
    usage_func
fi

echo preprod us-east-1
~/ownerTags/missingOwners.sh preprod us-east-1 $mydate --refresh
echo preprod us-west-2
~/ownerTags/missingOwners.sh preprod us-west-2 $mydate --refresh
echo prod us-east-1
~/ownerTags/missingOwners.sh prod us-east-1 $mydate --refresh
echo prod us-west-2
~/ownerTags/missingOwners.sh prod us-west-2 $mydate --refresh
