#!/bin/bash

set -xe

ssh_key="${1}"
if [[ ! -f "$ssh_key" ]]; then
  ssh_key="$HOME/.ssh/id_rsa"
fi
if [[ ! -z "$KUBECONFIG" ]]; then
  kubectl_location=$KUBECONFIG
fi

server=$(kubectl config view --minify | grep server | awk '{print $2}')
local_tunnel_url="https://kubernetes.default:8443"
kubectl_location="$HOME/.kube/config" 
cluster_name=$(kubectl config view --minify | grep name | head -n 1 | awk '{print $2}' | awk -F_ '{print $NF}')
server_ip=$(gcloud container clusters describe ${cluster_name} --format="value(endpoint)")
node_info=$(gcloud compute instances list | grep $cluster_name | head -n 1)
tunnel_node=$(echo "${node_info}" | awk '{print $1}')
tunnel_zone=$(echo "${node_info}" | awk '{print $2}')

sed -i "s~${server}~${local_tunnel_url}~g" $kubectl_location
cat /etc/hosts | grep kubernetes.default || echo "127.0.0.1 kubernetes kubernetes.default" | sudo tee -a /etc/hosts

gcloud compute ssh \
--zone $tunnel_zone \
$tunnel_node \
--ssh-key-file=$ssh_key \
--tunnel-through-iap \
--ssh-flag="-L 8443:${server_ip}:443"