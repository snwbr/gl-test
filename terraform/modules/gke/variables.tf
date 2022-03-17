variable "project" {
  type    = string
  default = "test-snwbr"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "cluster_initial_node_count" {
  type    = number
  default = 3
}

variable "create" {
  type    = bool
  default = false
}

variable "cluster" {
  type    = string
  default = "gl-gke"
}

variable "gke_version" {
  type    = string
  default = "1.21.9-gke.1002"
}

variable "machine_type" {
  default = "e2-small"
}

variable "gke_tags" {
  type    = list(string)
  default = []
}

variable "oauth_scopes" {
  type = list(string)
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "vpc_network" {
  type    = string
  default = null
}

variable "subnetwork_vpc_name" {
  type    = string
  default = null
}

variable "gke_service_account" {
  type    = string
  default = null
}

variable "node_pool_max_node_count" {
  type    = number
  default = 3
}

variable "cluster_secondary_range_name" {
  type    = string
  default = null
}

variable "services_secondary_range_name" {
  type    = string
  default = null
}

variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = null
}
