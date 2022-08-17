#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

if [ $# -eq 0 ]
  then
    echo "OpenSearch DNS Name is expected as parameter, like 'vpc-acs-opensearch-kwu4eqb2qmj745h7fdcoa5jp5e.eu-west-1.es.amazonaws.com'"
    exit 1
fi

OPENSEARCH_HOSTNAME=$1

sudo amazon-linux-extras install -y java-openjdk11

mkdir -p truststore/certificates

cd truststore && cd certificates

openssl s_client -showcerts -verify 5 -connect ${OPENSEARCH_HOSTNAME}:443 < /dev/null |
   awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".pem"; print >out}'
for cert in *.pem; do
        newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
        echo "${newname}"; mv "${cert}" "${newname}"
done

# Since Java doesn't accept default PKCS12 truststores produced with OpenSSL, using keytool is required
for cert in *.pem; do
    keytool -import -alias ${cert} -noprompt -file ${cert} -keystore ../truststore.pkcs12 -storetype PKCS12 -storepass sph3re
done


echo "-----------------------------------------"
echo "Generated output file truststore/truststore.pkcs12 file with password sph3re"
