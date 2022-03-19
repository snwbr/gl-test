#!/bin/bash
set -x

common="common"
services="services"
kustomize="./kustomize"
if [[ ! -f "kustomize" ]]; then
  if [[ ! -f "../kustomize" ]]; then
    echo "Unable to identify K8s folders. Run this script from k8s or from k8s/scripts folders."
    exit 1
  fi
  common="../$common"
  services="../$services"
  kustomize="../$kustomize"
fi
$kustomize build $common | kubectl apply -f -
$kustomize build $services | kubectl apply -f -
helm upgrade --install \
    --namespace=services \
    --values=$services/traefik/helm_values.yaml \
    traefik traefik/traefik
kubectl -n services 