#!/bin/bash

# Process instanceIds files and create/update the owner tags on the EC2 instances in AWS

usage_func() {
    echo 
    echo "Usage: "`basename $0`" [environment]"
    echo 
    echo "example: " `basename $0` "preprod"
    echo 
    exit 1
}

environment=$1

if [ "$environment" = "" ]; then
    usage_func
    exit 1
fi


source ~/bin/setenv.sh $environment

while read region resource owner
do
    aws ec2 create-tags --region $region --resources $resource --tags Key=owner,Value=$owner
done < ~/data/ownerTags/instanceIds_$environment.dat
