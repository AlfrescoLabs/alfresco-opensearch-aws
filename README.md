# AWS Deployment for Alfresco with Search Enterprise 3 using OpenSearch

From ACS 7.1 two Search Engines are available:

* [Search Services 1.x and 2.x](https://docs.alfresco.com/search-services/latest/), that is relaying on a customization of [Apache SOLR 6.6](https://solr.apache.org/guide/6_6/)
* [Search Enterprise 3.x](https://docs.alfresco.com/search-enterprise/latest/), that is a standard client for [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/7.10/index.html) and [Amazon OpenSearch](https://aws.amazon.com/opensearch-service/)

This project provides a *sample* deployment for ACS 7.2 with Alfresco Search Enterprise 3.1.0 using AWS Managed Services (**Amazon OpenSearch**, Amazon RDS and Amazon MQ). Note that deploying the product in *production* environments would require additional configuration.

Docker Images from [quay.io](https://quay.io/organization/alfresco) are used, since this product is only available for Alfresco Enterprise customers. If you are Enterprise Customer or Partner but you are still experimenting problems to download Docker Images, contact [Alfresco Hyland Support](https://community.hyland.com) in order to get required credentials and permissions.

## Docker Compose

Docker Compose template includes following files:

```
.
├── .env-RemovePostFix
├── docker-compose.yml
├── alfresco
│   └── Dockerfile
├── keystores
├── license
├── scripts
└── cfn-aws_resources_for_alfresco_opensearch.yml
```

* `.env-RemovePostFix` includes common values and service versions to be used by Docker Compose. A sample is provided (.env-RemovePostFix), save it as `.env` after values for your environment has been provided
* `docker-compose.yml` is a regular ACS Docker Compose, including Elasticsearch Connector and the endpoints provided by OpenSearch Service, RDS and MQ in AWS
* `Dockerfile` has the build instructions to customize default Alfresco Repository Docker Image.
* `keystores` folder is empty by default, copy your `truststore.pkcs12` file produced with `scripts/build-truststore.sh` tool
* `license` folder is empty be default, copy your `alfresco.lic` file in this folder
* `scripts` folder includes a set of bash scripts to configure the Alfresco EC2 Instance
* `cfn-aws_resources_for_alfresco_opensearch.yml` CloudFormation template to deploy AWS resources to run this Alfresco system


## Deploy AWS resources with Cloudformation

After deploying the AWS resources with the provided [Cloudformation template](./cfn-aws_resources_for_alfresco_opensearch.yml), retrieve values for your AWS environment on the Cloudformation stack's output tab.


## Preparing the Alfresco EC2 Instance

Before deploying Docker Compose templates, follow this steps to configure the EC2 Instance using the scripts available in `scripts` folder.

```
cd scripts
```

**Install Docker and Docker Compose**

```
./1-install-docker.sh
```

After this step, reboot the instance (use `sudo shutdown -r now` command). If the instance is powered off and then restarted (rather than rebooted), it is likely that the public ipv_4 address will change.

**Login quay.io**

```
./2-login-quay.sh
```

Credentials required to download Alfresco Docker Images from quay.io. Contact Alfresco Support to get them.


## Configure Docker Compose `.env` file with environmental values.
Use the values from your Cloudformation stack's output tab for for your environmental values

**Create Database**

```
./3-create-database <DatabaseEndPoint>
```

`<DatabaseEndPoint>` is the DB DNS Name created using the Cloud Formation Template, for instance `acs-opensearch-opensearchalfresco.cijbca5yttz2.eu-west-1.rds.amazonaws.com`


**Mount Filesystem**

```
./4-mount-efs.sh <FileSystemMount>
```

`<FileSystemMount>` is the EFS DNS Name created using the Cloud Formation Template, for instance `fs-06919b0d9d232efe3.efs.eu-west-1.amazonaws.com`


**Create TrustStore from OpenSearch**

```
./5-build-truststore.sh <OpenSearchDomainEndpoint>
```

`<OpenSearchDomainEndpoint>` is the OpenSearch DNS Name created using the Cloud Formation Template, for instance `vpc-acs-opensearch-kwu4eqb2qmj745h7fdcoa5jp5e.eu-west-1.es.amazonaws.com`

Once this script has been executed successfully, copy the produced `truststore/truststore.pkcs12` file to `keystores` folder

**Adding Alfresco License**

Copy your `alfresco.lic` file to `license` folder. Contact Alfresco Support to get a valid license file for ACS 7.2.


## Using

```
$ docker-compose up --build --force-recreate
```

## Service URLs

http://*ipv4OfAlfrescoServer*:8080/workspace

ADW
* user: admin
* password: admin

http://*ipv4OfAlfrescoServer*:8080/alfresco

Alfresco Repository
* user: admin
* password: admin
