## Project Variables
project = "test-snwbr"
region  = "us-central1"
env     = "dev"

## Service accounts
sa_gke_create = true

## Networking
gke_master_ipv4_cidr_block = "10.1.0.0/28"
gke_cidr_range             = "10.2.0.0/16"

gke_secondary_ip_range = [
  {
    secondary_ip_range_name = "pod"
    secondary_ip_range_cidr = "10.4.0.0/16"
  },
  {
    secondary_ip_range_name = "svc"
    secondary_ip_range_cidr = "10.6.0.0/16"
  }
]


## GKE
gke_create                 = true
zone                       = "us-central1-c"
cluster_initial_node_count = 3
cluster_name               = "gl-challenge"
gke_version                = "1.21.9-gke.1002"
machine_type               = "e2-small"
gke_tags                   = []
