#######################
## environment
#######################
#
variable "environment" {
  default = {
     homol : "homol",
     prod : "prod",
  }
}

#######################
## VPC
#######################
#
variable "vpc" {
  default = {
     homol : "homol",
     prod : "prod",
  }
}

variable "vpc_cdr" {
  default = {
     homol : "172.16.0.0/16",
     prod : "172.17.0.0/16",
  }
}