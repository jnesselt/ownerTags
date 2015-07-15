#!/bin/bash

# Build instance file including LaunchTime, KeyName, system and owner for account and region.
# Pull specified date from instance file and create subset file.

usage_func() {
    echo 
    echo "Usage: "`basename $0`" [environment] [region] [date (YYYY-MM-DD)] <--refresh>"
    echo 
    echo "example: " `basename $0` "us-east-1 2015-03-30 --refresh"
    echo 
    exit 1
}

environment=$1
region=$2
mydate=$3
refresh=$4

if [ "$environment" = "" -o "$region" = "" -o "$mydate" = "" ]; then
    usage_func
fi

source ~/bin/setenv.sh $environment

if [ "$refresh" = "--refresh" ]; then
    aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[LaunchTime,InstanceId,KeyName,Tags[?Key==`system`].Value | [0],Tags[?Key==`owner`].Value | [0]]' --output text > ~/data/ownerTags/$environment-$region-notify.dat
fi
grep $mydate.*None$ ~/data/ownerTags/$environment-$region-notify.dat > ~/data/ownerTags/$mydate-$environment-$region-notify.dat
~/ownerTags/missingOwners.pl $mydate $environment $region
