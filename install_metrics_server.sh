#!/bin/bash

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl get deployments.apps metrics-server -n kube-system -o yaml | \
sed -e "s/- args:/- args:\n        - --kubelet-insecure-tls/" | \
kubectl apply -f - -n kube-system