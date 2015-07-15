usage_func() {
    echo "Create tab delimited instance file by account and region and upload to Confluence as an attachment to a document"
    echo "Usage: "`basename $0`" [environment] [region]"
    echo 
    echo "example: " `basename $0` "preprod us-east-1"
    echo 
    exit 1
}

environment=$1
region=$2

if [ "$environment" = "" -o "$region" = "" ]; then
    usage_func
fi

if [ "$environment" == "preprod" ]; then
    source ~/bin/setenv.sh preprod
    pageId=111872589
    if [ "$region" == "us-east-1" ]; then
        attachmentId=att111872591
    elif [ "$region" == "us-west-2" ]; then
        attachmentId=att111872597
    fi
elif [ "$environment" == "prod" ]; then
    source ~/bin/setenv.sh prod
    pageId=112656599
    if [ "$region" == "us-east-1" ]; then
        attachmentId=att112656597
    elif [ "$region" == "us-west-2" ]; then
        attachmentId=att112656598
    fi
fi
# Create tab delimited instance file by account and region
echo -e InstanceId'\t'State'\t'KeyName'\t'Name Tag'\t'group Tag'\t'system Tag'\t'owner Tag - Email > ~/data/ownerTags/tempfile1.dat
aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,KeyName,Tags[?Key==`Name`].Value | [0],Tags[?Key==`group`].Value | [0],Tags[?Key==`system`].Value | [0],Tags[?Key==`owner`].Value | [0]]' --output text >> ~/data/ownerTags/tempfile1.dat

~/ownerTags/addExceededTagCounts.py ~/data/ownerTags/tempfile1.dat ~/data/ownerTags/tempfile2.dat 

# Remove Teminated Instances
grep -v ^i-.........terminated ~/data/ownerTags/tempfile2.dat > ~/data/ownerTags/$environment-$region-ownerTags.dat

# Upload tab delimited attachment file to Confluence
curl -D- -u jnesselt:`cat ~/data/ownerTags/pw.dat` -X POST -H "X-Atlassian-Token: nocheck" -F "file=@$HOME/data/ownerTags/$environment-$region-ownerTags.dat" https://proquest.atlassian.net/wiki/rest/api/content/$pageId/child/attachment/$attachmentId/data
echo

rm -f ~/data/ownerTags/tempfile1.dat
rm -f ~/data/ownerTags/tempfile2.dat
