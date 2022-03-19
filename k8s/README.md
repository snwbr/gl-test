# K8s code
## Overview

This code serves as the K8s objects main source. It contains all the templates for deploying the applications, alongisde the key components for the cluster to work successfully (i.e. cert-manager, traefik, deployments, services, etc).

Since GKE clusters are private, you cannot directly access the control plane's IP or the kube API. Instead, you need to use a bastion/jump host/proxy to achieve a connection from your machine. To do so, there is a helper script called [tunnel.sh](scripts/tunnel.sh), just call it `./scripts/tunnel.sh` and it will do the following steps:

1. Get necessary variables to set up your local config files.
2. Modify your K8s current context's endpoint to a local endpoint (`~/.kube/config` or another config defined in `$KUBECONFIG` environment variable).
3. Add to `/etc/hosts` an entry for the local endpoint to use.
4. Start a proxy session using one of the GKE nodes in the cluster.
5. Leave that session open. In another shell tab, test your connection by doing `kubectl get ns`

**NOTES:** 
- It is assumed you already created the necessary IAP rules to access the private nodes via IAP SSH tunnel (which is done by applying the resources [here](../terraform/infra/gl/iap.tf)).
- The script will work against the GKE cluster that is currently in use (the one that is active as the kubectl current context, you can check it by doing `kubectl config current-context` and `kubectl config view --minify`). If you have not gotten the GKE credentials yet, get them with the following command:

```
## If you have not set up the gcloud auth credentials already, do it like this
gcloud config configurations create snwbr ## change 'snwbr' for any config name you want to have, i.e. 'dev'

## specify the name and location of your service account key.
gcloud auth activate-service-account terraform-sa@test-snwbr.iam.gserviceaccount.com --key-file=snwbr.json

## Optionally, you can set your main region and project for each configuration, so that you don't have to specify it in every command
gcloud config set project test-snwbr
gcloud config set compute/region us-central1

## Get the GKE credentials. Modify the cluster name (dev-gke), region and project as needed.
gcloud container clusters get-credentials dev-gke --region us-central1 --project test-snwbr

## Now you can run the tunnel script
./scripts/tunnel.sh
```

## Templating

In order to reuse code (as most of the objects will be the same across environments), [`kustomize`](https://github.com/kubernetes-sigs/kustomize) is used. Kustomize is a tool that creates K8s manifests based on base manifests and overlays that can be environments customization, different services or even configurations for different clouds. It merges the customizations of each subfolder with the base manifests to generate new and specific manifests for each of the overlays.

### Kustomize installation

```
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
```

## Folders structure

```
.
├── README.md
├── apps
│   ├── base
│   │   └── kustomization.yaml
│   ├── dev
│   │   ├── app1
│   │   │   ├── kustomization.yaml
│   │   ├── app2
│   │   │   ├── kustomization.yaml
│   │   ├── etc...
│   │   │   ├── kustomization.yaml
│   │   └── kustomization.yaml # (builds all apps in dev folder)
├── common
│   ├── k8s
│   │   └── base
│   │       ├── kustomization.yaml
│   └── kustomization.yaml # (builds all apps in 'common' folder)
├── services
│   ├── cert-manager
│   │   └── base
│   │       └── kustomization.yaml
│   ├── etc...
│   └── kustomization.yaml # (builds all apps in 'services' folder)
```

## Usage

```
./kustomize build apps/dev/app1 > app1.yaml
./kustomize build common > common.yaml
./kustomize build services > services.yaml

## to render all of the manifests in one environment, you may use the command
## below. Reason is if there are two objects with the same name, it may collide.
## To overcome this, the folder organization may change or rely on the idempotation
## of Kubernetes when there is an object that already exists.
## In other words, this won't work: ./kustomize build apps/dev > dev.yaml
ls -d apps/dev/*/ | xargs -I{} ./kustomize build {} > dev.yaml

## it can also apply directly on a K8s cluster
kustomize build common | kubectl apply -f -
```

## Motivation
Yet another way to do templating. There is also Helm, for example. For the challenge, I chose kustomize and Helm because I wanted to be as much K8s-native as possible, also it's pretty easy to have multiple environments templated and I think kustomize is underrated, so I wanted to give some exposure. Kustomize is more than enough for a simple task such as a challenge. 

For more complex environments and situations, Helm or jsonnet may be used as well, although kustomize is still pretty powerful.

For traefik install, for instance, we're using Helm, in order to serve as a Helm first-glance or proof of how to use it. Helm can be installed with:

```
cd scripts
./get_helm.sh
```

After installation, you can install traefik like this:

```
helm repo add traefik https://helm.traefik.io/traefik
helm install \
--namespace=services \
--values=services/traefik/helm_values.yaml \
traefik traefik/traefik
```

Taefik dashboard can be accessed via a `kubectl port-forward`. This is done on purpose, for security reasons the Dashbord SHOULD NOT be publically exposed:

```
kubectl port-forward -n services deployment/traefik 9000:9000
```

## Secrets management

The project uses kubeseal to have a way to encrypt the k8s secrets by using an operator that enables encryption by obtaining an encrypting key ONLY from the controller in the specific cluster. Thus, there is no way to decrypt the secrets if not using such controller. This allows us to upload the secrets to the git repo for a nicer GitOps experience.

The operator documentation can be found [here](https://github.com/bitnami-labs/sealed-secrets).

There are two parts: the controller (residing in K8s) and the local client binary to seal the secrets locally (called `kubeseal`).

To install `kubeseal`, run the following:

```
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.3/kubeseal-0.17.3-linux-amd64.tar.gz
sudo tar -xzvf kubeseal-0.17.3-linux-amd64.tar.gz -C /usr/bin/ kubeseal
```

In order to seal a secret, do as follows:

```
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json
kubeseal <mysecret.json >mysealedsecret.json

## then you can apply it to k8s and save the file in the repo
kubectl create -f mysealedsecret.json
```

However, since we're working with a private cluster for security reasons, you need to retrieve the controller's certificate to seal the secrets. The certificate is printed to the controller's logs, which you can see by doing:

```
kubectl logs -n kube-system $(kubectl get pods -n kube-system | grep sealed-secrets | awk '{print $1}')
```

Once you get it, save it somewhere and refer to it when running `kubeseal`:

```
## taking advantage of the example to show how to export to yaml instead of json, if preffered
cat mysecret.json | kubeseal -o yaml --cert=cert.pem > mysealedsecret.yaml
```