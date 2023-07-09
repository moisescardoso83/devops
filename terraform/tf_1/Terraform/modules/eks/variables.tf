variable "cluster-name" {
  type = string
}

variable "instance_types" {
  type = list(string)
   default = ["c3.large","c4.large","c5.large", "c5d.large", "c5n.large","c5a.large"]
}

variable "desired_size" {
  type = string
}

variable "min_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "tag_environment" {
  description = "tag Environment"
  type        = string
}