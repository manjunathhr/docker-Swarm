#!/usr/bin/env bash

DOCKER_VERSION=$1

#!/bin/bash
sudo yum-config-manager --add-repo http://10.176.72.70:5558/artifactory/cdos-yum
sudo yum clean expire-cache
sudo yum install -y amazon-efs-utils
sudo yum install -y docker-ce --nogpgcheck -y
sudo yum install docker-ce-cli --nogpgcheck -y
sudo yum install containerd.io --nogpgcheck -y 
sudo systemctl start docker 
sudo systemctl enable docker
sudo curl -L http://10.176.72.70:5558/artifactory/cdos-yum/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
