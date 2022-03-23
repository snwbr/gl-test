# Gorilla Logic DevOps test

## Table of Contents  
  - [Table of Contents](#table-of-contents)
  - [Summary](#summary)
  - [Architecture](#architecture)
  - [Infrastructure as Code](#infrastructure-as-code)
  - [Kubernetes](#kubernetes)
  - [Continuous Integration & Continuous Deployment](#continuous-integration--continuous-deployment)
  - [Artifacts](#artifacts)
  - [Improvements](#improvements)



## Summary
This repo contains the necessary code to deploy the Gorilla Logic DevOps test, which encourages people to use best practices to deploy an application to an environment that's fully automated, scalable, high available and reliable.

## Architecture
### Toolset and technologies

- Cloud provider: Google Cloud
- Infrastructure as Code: Terraform
- CI/CD: Jenkins
- K8s teamplating: kustomize
- K8s installation manager: Helm
- Reverse proxy, routing, service discovery and TLS termination: Traefik
- K8s CNI: Calico
- Certificates management: Cert-manager
- Domain provider: Google Domains

### High level architecture diagram
![diagram.svg](diagram.svg)

### Highlights and motivation
The challenge was split into two different repos:
- https://github.com/snwbr/gl-test/ (this repoo) contains all the base code to configure the cloud of chosing, to spin up the environment and handle underlaying objects required for the app to be deployed and run successfully. For details, read the sections below.
- https://github.com/snwbr/timeoff-management-application/ is an actual application to be build, tested and deployed over the environment previously configured.

## Infrastructure as Code

For creating objects in the cloud, Terraform was chosen. Terraform code is splitted by enviornments (see the [README](terraform/README.md)).

Terraform manages the construction of the Virtual Private Network, as well as the Identity-Aware Proxy (Cloud IAP) to connect from remote locations to the private network resources. Also, the GCP project's API are managed through Terraform. Rest of objects (firewall rules, dns names, NAT, routers, service accounts, etc) are part of it.

## Kubernetes

During this challenge, Google Kubernetes Enginer (GKE) was chosen. The configuration is as follows:
- Private cluster, with no direct access to internet (no node has public IP)
- Node autoscaling is enabled, for High Availability.
- 


## Continuous Integration & Continuous Deployment



## Artifacts



## Improvements