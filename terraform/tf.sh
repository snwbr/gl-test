#!/bin/bash
ENV="${1}"
ACTION="${2}"

terraform init -var-file=tfvars/$ENV.tfvars
terraform $ACTION -var-file=tfvars/$ENV.tfvars "${@:3}"
