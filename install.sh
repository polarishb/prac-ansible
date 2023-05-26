#!/bin/bash

echo "Start install Kubernetes"

ansible-playbook configure-ansible.yml
ansible-playbook set-hosts.yml
ansible-playbook install-kubernetes.yml
ansible-playbook install-haproxy.yml

## Kubectl 설정
if [ ! -d "/source" ]; then
    mkdir /sources
    echo "Created /sources"
else
    echo "/sources already exists"
fi

if [ ! -f "/sources/admin.conf "]; then
    scp root@k8s-master01:/etc/kubernetes/admin.conf /sources/
    echo "Copied kubernetes cluster configure file"
else
    echo "configure file already exists"
fi
ansible-playbook config-cluster.yml

