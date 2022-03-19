# Terraform code
## Overview

This code serves as the IaC main source. It will spin up resources, GCP project's configurations, necessary VPC, subnets, routers, NAT, etc. Code also contains the definition of the GKE cluster used to deploy the apps.

You need a valid `terraform-sa.json` in this folder (next to the README) containing a valid GCP service account. TODO: in real environments, one posibility for handling this file's location should be set as an environment variable and the contents be managed through the secrets management tool of chosing.

## Prerequisites

**NOTE:** Projects run to be done just during the first setting up.

In addition to the `terraform-sa.json` service account key, you need to know that project's APIs should be enabled before running the rest of the code, in addition to any project specific resoruces, if any. Run this as the first terraform run:

```
cd infra/projects
./tf.sh dev apply

## Then, you can run the rest of the modules and resources
cd ../infra/gl
./tf.sh dev apply
```

## Folders structure

```
.
├── README.md
├── infra
│   └── gl
│       ├── backend.tf
│       ├── firewall.tf
│       ├── gke.tf
│       ├── iap.tf
│       ├── nat.tf
│       ├── project.tf
│       ├── providers.tf
│       ├── service_accounts.tf
│       ├── tf.sh -> ../../tf.sh
│       ├── tfvars
│       │   └── dev.tfvars
│       ├── variables.tf
│       └── vpc.tf
├── modules
│   ├── gke
│   │   ├── google_container_cluster.tf
│   │   ├── google_container_node_pool.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── network
│   │   ├── nat
│   │   │   ├── google_compute_router.tf
│   │   │   ├── google_compute_router_nat.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── subnet
│   │   │   ├── google_compute_subnetwork.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── google_compute_network.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── project
│   │   ├── google_project_service.tf
│   │   └── variables.tf
│   └── service-accounts
│       ├── google_service_account.tf
│       ├── outputs.tf
│       └── variables.tf
├── terraform-sa.json
└── tf.sh
```

## Usage
There is a `tf.sh` script symbolic link in each of the infra folders. To execute Terraform on them, it's necessary to go into a folder (i.e. [infra/gl](infra/gl)) and execute as follows:

```
./tf.sh ENV ACTION [OPTIONS]
```

Where:

`ENV`: refers to the environment. Currently only `dev` environment is supported for the challenge purpose.

`ACTION`: any Terraform action, such as `plan`, `apply`, `destroy`, `taint`, `state`, `fmt`, `output`, etc.

`OPTIONS`: any other possible option(s) you may want to add, for example `-target=module.gke`, `-compact-warnings`, `-out=plan.out`, etc.


## Structure motivation
There are infinite ways to organize the Terraform code, some of them are more painful than others. For the challenge, I chose to create one `infra` folder and one `modules` folder (modules also could be separated in a different git repo for isolated testing) with the hope of split and reuse the resources in different environments. Such environments may reside in the `infra` folder, currently the only infra folder is `gl`. This `infra` folder could also be renamed or seen as products, services, resources, tiers, etc, depending on how big or complex is the codebase and the requirement.

In the `infra` folder, there is a `tfvars` folder with different `tfvars` there that specifies the different configurations based on the environment one's working with. At the moment of writing, the only environment is `dev`. The creation of the `tf.sh` scripts aims to solve the passing of the `tfvars` file depending on the environment, to avoid putting `-var-file=dev.tfvars` everytime one plans, and it also gives room for more terraform commands' customization, such as setting environment variables, remote backends (and use dynamic backends) and more once in the script, without having to specify them everytime one run `terraform` comands.