#!/bin/bash

echo "Start install Kubernetes"

ansible-playbook configure-ansible.yml
ansible-playbook set-hosts.yml

# 모듈 설치
var=$(ansible-galaxy collection list | grep community.crypto | awk {'print $1'})
if ! [ $var == "community.crypto" ]; then
    ansible-galaxy collection install community.crypto
fi
var=$(ansible-galaxy collection list | grep community.general | awk {'print $1'})
if ! [ $var == "community.general" ]; then
    ansible-galaxy collection install community.general
fi
var=$(ansible-galaxy collection list | grep ansible.posix | awk {'print $1'})
if ! [ $var == "ansible.posix" ]; then
    ansible-galaxy collection install ansible.posix
fi


ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general

ansible-playbook install-kubernetes.yml
ansible-playbook install-haproxy.yml

## Kubectl 설정
if [ ! -d "/source" ]; then
    mkdir /sources
    echo "Created /sources"
else
    echo "/sources already exists"
fi

# Kubernetes Cluster 생성 및 연결
ansible-playbook init-master.yml
ansible-playbook config-cluster.yml