#!/usr/bin/env bash

# This script is used to create the build image that is utlized by the Datahub Staging instance.
# It is meant to be used when the build image is created for the very first time, as well as if 
# the build image ever needs to be rebuilt (e.g. if the cbioportal instance needs to be updated)

# clone cbioportal-docker-compose repo
echo "CLONING CBIOPORTAL REPO"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
git clone https://github.com/cBioPortal/cbioportal-docker-compose.git

cd cbioportal-docker-compose

echo "RUNNING INITIALIZATION SCRIPT"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
# run init script to get necessary items to port into cotnainer
./init.sh


echo "REMOVING INVALID DOCKER COMPOSE SYNTAX FOR OKTETO"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
# remove :ro, with isn't supported in Okteto's build service
sed -i '' 's/:ro//g' docker-compose.yml

echo "SETTING OKTETO CONTEXT"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
# set context to push build image to
okteto context use https://cloud.okteto.com 

echo "BUILDING IMAGE USING OKTETO"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
okteto build