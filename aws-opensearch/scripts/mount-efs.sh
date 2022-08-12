#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

if [ $# -eq 0 ]
  then
    echo "EFS DNS name is required as parameter, like 'fs-06919b0d9d232efe3.efs.eu-west-1.amazonaws.com'"
    exit 1
fi

EFS_HOSTNAME=$1

sudo mkdir /efs

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_HOSTNAME:/ /efs
