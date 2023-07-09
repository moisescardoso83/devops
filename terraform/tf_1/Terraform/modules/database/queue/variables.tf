variable "broker_name" {
  type = string
}

variable "deployment_mode" {
  type = string
}

variable "engine_type" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_ids" {
  #type = list(string)
  type = string
}

variable "vpc_id" {
   type = string
}
