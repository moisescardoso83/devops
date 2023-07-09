variable "cluster_identifier" {
  type = string
}
variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "preferred_backup_window" {
  type = string
}

variable "copy_tags_to_snapshot" {
  type = bool
}

variable "db_cluster_parameter_group_name" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "deletion_protection" {
  type = bool
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  #default = ["audit","error","general","slowquery"]
}

variable "serverlessv2_scaling_configuration" {
  type = list(object({
    max_capacity = number
    min_capacity = number
  }))
}

variable "skip_final_snapshot" {
  type = bool
}

variable "vpc_security_group_ids" {
  type = list(string)
}
