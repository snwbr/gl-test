variable "project" {
  type    = string
  default = null
}

variable "name" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "ip_cidr_range" {
  type    = string
  default = null
}

variable "vpc_network" {
  type    = string
  default = null
}

variable "secondary_ip_range" {
  type    = list(map(string))
  default = []
}
