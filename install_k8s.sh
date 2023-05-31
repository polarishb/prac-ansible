#!/bin/bash

echo "Start install Kubernetes"

# 쿠버네티스 클러스터 hosts, ssh 설정
ansible-playbook /sources/init-k8s-cluster.yml

# 쿠버네티스 클러스터 환경 구축
ansible-playbook /sources/install-kubernetes.yml
ansible-playbook /sources/install-haproxy.yml
ansible-playbook /sources/install-keepalived-Master.yml
ansible-playbook /sources/install-keepalived-Backup.yml

# Kubernetes Cluster 생성
ansible-playbook /sources/init-cluster.yml

# Join Token 추출
sed -n '/^\s.*kubeadm/,/control-plane/p' /sources/initial_log > /sources/Master
sed -i 's/\\//g' /sources/Master
sed -n '/^kubeadm/,/discovery/p' /sources/initial_log > /sources/Worker
sed -i 's/\\//g' /sources/Worker

# 노드 Join
ansible-playbook /sources/init-master.yml
ansible-playbook /sources/init-worker.yml

# kubectl admin.conf 설정
ansible-playbook /sources/config-cluster.yml

# 스토리지 서버 마운트
ansible-playbook /sources/mount-nfs.yml

# CNI 설치
curl https://docs.projectcalico.org/archive/v3.17/manifests/calico.yaml -O /sources/calico.yaml --insecure
ansible-playbook /sources/set-cni.yml

# MetalLB 설치
ansible-playbook install-metallb.yml

# Helm 설치
curl -fsSL -o /sources/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod u+x /sources/get_helm.sh
/sources/get_helm.sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm pull prometheus-community/kube-prometheus-stack --untar --untardir /sources/
ansible-playbook install-helm.yml
ansible-playbook install-prometheus.yml
ansible-playbook expose-grafana.yml

echo "Kubernetes Install & Configuration Finished"