#!/bin/bash

echo "Initialize Ansible Server"

# 모듈 설치 ( Ansible 2.10 or above)
#var=$(ansible-galaxy collection list | grep -o community.crypto)
#if ! [ $var == "community.crypto" ]; then
#    ansible-galaxy collection install community.crypto
#fi
#var=$(ansible-galaxy collection list | grep -o community.general)
#if ! [ $var == "community.general" ]; then
#    ansible-galaxy collection install community.general
#fi
#var=$(ansible-galaxy collection list | grep -o ansible.posix)
#if ! [ $var == "ansible.posix" ]; then
#    ansible-galaxy collection install ansible.posix
#fi

# 모듈 설치 ( Ansible 2.9 )
loc=.ansible/collections/ansible_collections/
if [ ! -d $HOME/$loc/community/general ]; then
   ansible-galaxy collection install community.general
else
    echo "Collection Communitiy General already installed."
fi
if [ ! -d $HOME/$loc/community/crypto ]; then
   ansible-galaxy collection install community.crypto
else
    echo "Collection Communitiy Crypto already installed."
fi
if [ ! -d $HOME/$loc/ansible/posix ]; then
   ansible-galaxy collection install ansible.posix
else
    echo "Collection Ansible Posix already installed."
fi
if [ ! -d $HOME/$loc/kubernetes/core ]; then
    ansible-galaxy collection install kubernetes.core
else
    echo "Collection Kubernetes Core already installed"
fi

# Ansible Host 설정
where=$(cd "$(dirname "$0")" ; pwd -P)

ansible-playbook $where/playbook/configure-ansible.yml
ansible-playbook $where/playbook/keyscan.yml
ansible-playbook $where/playbook/pre-install.yml -k