variable "project" {
  type    = string
  default = null
}

variable "service_account_users" {
  type    = list(string)
  default = []
}

variable "sa_roles_list" {
  type    = list(string)
  default = []
}

variable "description" {
  type    = string
  default = null
}

variable "create" {
  type    = bool
  default = false
}

variable "name" {
  type    = string
  default = ""
}