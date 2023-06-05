#!/bin/bash

echo "Start install Kubernetes"
where=$(cd "$(dirname "$0")" ; pwd -P)

# 쿠버네티스 설정
ansible-playbook $where/playbook/init-k8s-cluster.yml

# 쿠버네티스 클러스터 환경 구축
ansible-playbook $where/playbook/install-kubernetes.yml
ansible-playbook $where/playbook/install-haproxy.yml
ansible-playbook $where/playbook/install-keepalived-Master.yml
ansible-playbook $where/playbook/install-keepalived-Backup.yml

# Kubernetes Cluster 생성
ansible-playbook $where/playbook/init-cluster.yml

# Join Token 추출
sed -n '/^\s.*kubeadm/,/control-plane/p' /sources/initial_log > /sources/Master
sed -i 's/\\//g' /sources/Master
sed -n '/^kubeadm/,/discovery/p' /sources/initial_log > /sources/Worker
sed -i 's/\\//g' /sources/Worker

# 노드 Join
ansible-playbook $where/playbook/init-master.yml
ansible-playbook $where/playbook/init-worker.yml

# kubectl admin.conf 설정
ansible-playbook $where/playbook/config-cluster.yml

# 스토리지 서버 설정 및 마운트
ansible-playbook $where/playbook/init-storage.yml
ansible-playbook $where/playbook/mount-nfs.yml

# CNI 설치
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml -o /sources/calico.yaml --insecure
ansible-playbook $where/playbook/set-cni.yml

# MetalLB 설치
ansible-playbook $where/playbook/install-metallb.yml

# Metrics-Server 설치
ansible-playbook $where/playbook/install-metrics-server.yml

# Helm 설치
curl -fsSL -o /sources/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod u+x /sources/get_helm.sh
/sources/get_helm.sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm pull prometheus-community/kube-prometheus-stack --untar --untardir /sources/
ansible-playbook $where/playbook/install-helm.yml

# 모니터링 설치
ansible-playbook $where/playbook/install-prometheus.yml
ansible-playbook $where/playbook/expose-grafana.yml

echo "Kubernetes Install & Configuration Finished"