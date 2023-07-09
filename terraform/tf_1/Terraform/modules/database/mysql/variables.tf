variable "region" {
#  default     = "us-east-1"
}

variable "vpc_id" {
#  default = "vpc-02b63a2247440e2b5"
}

variable "subnet_ids" {
  type        = list(string)
}

variable "db_instance_identifier" {
#  default     = "mysql-poc-01"
}

#variable "db_name" {
##  default     = "db_1"
#}

variable "db_username" {
#  default     = "mysql"
}

variable "db_password" {
#  default     = "mysql-Feb252023"
}

#variable "db_subnet_group_name" {
##  default     = "subnet-mysql-01"
#}

#variable "db_security_group_ids" {
#  description = "A list of security group IDs to associate with the RDS instance"
#  type        = list(string)
#  default     = "sg-0f551cfd7e1de23cf"
#}


variable "allocated_storage" {
#  default     = 20
}

variable "engine" {
#  default     = "mysql"
}

variable "engine_version" {
#  default     = "8.0.28"
}

variable "instance_class" {
#  default     = "db.m6i.large"
}

variable "storage_type" {
#  default     = "gp3"
}

#variable "backup_retention_period" {
##  default     = 7
#}

#variable "db_parameter_group_name" {
##  default     = "my-db-parameter-group"
#}

variable "multi_az" {
#  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
}

