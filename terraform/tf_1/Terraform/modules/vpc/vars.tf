variable "az_count" {
  default     = "3"
  description = "number of availability zones in above region"
  type        = string
}

variable "tag_environment" {
  description = "tag Environment"
  type        = string
}

variable "region" {
  description = "region Environment"
  #type        = list(string)
}

variable "cidr_block" {
  description = "cdir Environment"
}

