#!/bin/bash

## This script must be executed with root user

if rpm -q ansible.noarch
then
  yum install ansible
fi
 
ansible-playbook configuration/site.yml

cd orchestration/k8s-cluster

terraform init && terraform apply

cd -
