#!/bin/bash

kubectl get services prometheus-grafana -n monitoring -o yaml | \
sed -e "s/type: ClusterIP/type: LoadBalancer/" | \
kubectl apply -f - -n monitoring