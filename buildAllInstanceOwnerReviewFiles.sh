#!/bin/bash

# Build and upload Instance Owner Files for all Accounts / Regions

~/ownerTags/buildInstanceOwnerReviewFile.sh preprod us-east-1
~/ownerTags/buildInstanceOwnerReviewFile.sh preprod us-west-2
~/ownerTags/buildInstanceOwnerReviewFile.sh preprod eu-west-1
~/ownerTags/buildInstanceOwnerReviewFile.sh prod us-east-1
~/ownerTags/buildInstanceOwnerReviewFile.sh prod us-west-2
~/ownerTags/buildInstanceOwnerReviewFile.sh prod eu-west-1
~/ownerTags/buildOwnerMappingFiles.pl
~/bin/convert.sh -d'\t' -f ~/data/ownerTags/systemMappings.dat > /var/www/html/systemMappings.html
