variable "project" {
  type    = string
  default = null
}

variable "type" {
  type    = string
  default = null
}

variable "default_ttl" {
  type    = number
  default = 300
}

variable "zone" {
  type    = string
  default = null
}

variable "data" {
  type    = list(any)
  default = null
}
