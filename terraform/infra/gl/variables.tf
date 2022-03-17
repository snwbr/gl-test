variable "project" {
  type    = string
  default = "test-snwbr"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "env" {
  type    = string
  default = null
}

variable "cluster_name" {
  type    = string
  default = "gl-gke"
}

variable "credentials" {
  type    = string
  default = "../../terraform-sa.json"
}

variable "gke_version" {
  type    = string
  default = "1.21.9-gke.1002"
}

variable "cluster_initial_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "gke_tags" {
  type    = list(string)
  default = []
}

variable "gke_create" {
  type    = bool
  default = false
}

variable "sa_gke_create" {
  type    = bool
  default = false
}

variable "gke_cidr_range" {
  type    = string
  default = null
}

variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "gke_secondary_ip_range" {
  type    = list(map(string))
  default = []
}