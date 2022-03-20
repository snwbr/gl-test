#!/bin/bash
set -x

env=$1
if [[ -z $env ]]; then
  echo "Provide an environment for the stack installation. Exiting..."
  exit 1
fi

common="common"
services="services"
apps="apps/${env}"
kustomize="./kustomize"
if [[ ! -f "kustomize" ]]; then
  if [[ ! -f "../kustomize" ]]; then
    echo "Unable to identify K8s folders. Run this script from k8s or from k8s/scripts folders."
    exit 1
  fi
  common="../$common"
  services="../$services"
  apps="../$apps"
  kustomize="../$kustomize"
fi
$kustomize build $common | kubectl apply -f -
helm upgrade --install \
    --namespace=services \
    --values=$services/traefik/helm_values.yaml \
    traefik traefik/traefik
sleep 10
$kustomize build $services | kubectl apply -f -
kubeseal -f $services/jenkins/ignore.git_ssh_secret.yaml -oyaml > $services/jenkins/base/git-gl-test-ssh.yaml
kubeseal -f $services/jenkins/ignore.gcp-sa.yaml -oyaml > $services/jenkins/base/gcp-sa.yaml
sleep 10
## rerunning services as sometimes cert-manager can take a while to register the CRDs
$kustomize build $services | kubectl apply -f -
sleep 10
$kustomize build $apps | kubectl apply -f -

