#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

if [ $# -eq 0 ]
  then
    echo "Database DNS Name is expected as parameter, like 'acs-opensearch-opensearchalfresco.cijbca5yttz2.eu-west-1.rds.amazonaws.com'"
    exit 1
fi

DB_HOSTNAME=$1

sudo amazon-linux-extras install -y postgresql13

PGPASSWORD=alfresco psql --host=$DB_HOSTNAME --dbname postgres \
     --username=alfresco \
     --command="CREATE DATABASE alfresco OWNER alfresco ENCODING 'utf8'"

PGPASSWORD=alfresco psql --host=$DB_HOSTNAME --dbname postgres \
     --username=alfresco \
     --command="GRANT ALL PRIVILEGES ON DATABASE alfresco TO alfresco"
