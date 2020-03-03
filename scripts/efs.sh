#!/usr/bin/env bash

set -ex

touch /tmp/testing
touch /tmp/efs.log

echo 'REGION 1 :  ${REGION}' | tee -a /tmp/efs.log
echo 'efs_id 1 :  ${efsid}' | tee -a /tmp/efs.log
echo 'Number of arguments $0 : ', {$0} | tee -a /tmp/efs.log
echo 'Number of arguments $1 : ', {$1} | tee -a /tmp/efs.log
echo 'Number of arguments $2 : ', {$2} | tee -a /tmp/efs.log

# Extract "host" argument from the input into HOST shell variable
efs_id='terraform output efs_file_system_id'
eval "$(jq -r '@sh "efs_id0=\(.efsid)"')"
echo 'efs_id 2 :  $efs_id' | tee -a /tmp/efs.log

whoami | tee -a /tmp/efs.log

# Mount EFS
mkdir -p /mnt/efs

# Install Utilities
yum-config-manager --enable epel | tee -a /tmp/yum.log
yum update -y | tee -a /tmp/yum.log
yum -y install nfs-utils | tee -a /tmp/yum.log

mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 ${efsid}.efs.eu-west-2.amazonaws.com:/ /mnt/efs

# Edit fstab so EFS automatically loads on reboot
echo "${efsid}:.efs.eu-west-2a.amazonaws.com/ /mnt/efs nfs nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 0 2" | tee -a /etc/fstab
