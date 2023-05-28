#!/bin/bash

echo "Initialize Ansible Server"

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

# Ansible Host 설정
ansible-playbook configure-ansible.yml
ansible-playbook ansible-ssh-keygen.yml

echo "Start install Kubernetes"

# 쿠버네티스 클러스터 hosts, ssh 설정
ansible-playbook init-k8s-cluster.yml

# 쿠버네티스 클러스터 환경 구축
ansible-playbook install-kubernetes.yml
ansible-playbook install-haproxy.yml

# Kubernetes Cluster 생성 및 연결
ansible-playbook init-cluster.yml
ansible-playbook config-cluster.yml

# 노드 Join
ansible-playbook init-master.yml
ansible-playbook init-worker.yml