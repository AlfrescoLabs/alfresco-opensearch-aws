#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo chkconfig docker on

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "------------------------------------------------------------------"
echo "IMPORTANT: reboot this instance to apply the changes (sudo reboot)"
