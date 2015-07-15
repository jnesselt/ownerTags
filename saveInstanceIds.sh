#!/bin/bash

# backup already processed instanceIds by pushOwnerTag.sh

cat ~/data/ownerTags/instanceIds_prod.dat    >> ~/data/ownerTags/instanceIds_prod.dat.back
cat ~/data/ownerTags/instanceIds_preprod.dat >> ~/data/ownerTags/instanceIds_preprod.dat.back
rm ~/data/ownerTags/instanceIds_prod.dat; touch ~/data/ownerTags/instanceIds_prod.dat
rm ~/data/ownerTags/instanceIds_preprod.dat; touch ~/data/ownerTags/instanceIds_preprod.dat
