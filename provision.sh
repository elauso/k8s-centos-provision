#!/bin/bash

## This script must be executed with root user

## Script params: 
## --k8s-provision-only: Provision only k8s resources

execute_ansible=true

for arg in "$@" ; do
  if [ "$arg" == "--k8s-provision-only" ] ; then
    execute_ansible=false
  fi
done

if [ "$execute_ansible" = true ] ; then
  if rpm -q ansible.noarch ; then
    yum install ansible
  fi
  ansible-playbook configuration/site.yml
fi

cd orchestration/k8s-cluster-resources
terraform init && terraform apply -auto-approve
cd -
