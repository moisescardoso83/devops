## modules/rds_mysql/main.tf
#resource "aws_db_instance" "rds_instance" {
#  db_instance_identifier       = var.db_instance_identifier
#  allocated_storage            = var.allocated_storage
#  engine                       = var.engine
#  engine_version               = var.engine_version
#  instance_class               = var.instance_class
#  db_subnet_group_name         = var.db_subnet_group_name
#  vpc_security_group_ids       = var.vpc_security_group_ids
#  db_parameter_group_name      = var.db_parameter_group_name
#  db_name                      = var.db_name
#  db_username                  = var.db_username
#  db_password                  = var.db_password
#  backup_retention_period      = var.backup_retention_period
#  multi_az                     = var.multi_az
#  storage_type                 = var.storage_type
#  db_security_group_names      = var.db_security_group_names
#}
#
## Variables
#variable "region" {
#  description = "The AWS region where to create the RDS instance"
#  type        = string
#}
#
#variable "db_instance_identifier" {
#  description = "The name of the RDS instance"
#  type        = string
#}
#
#variable "db_name" {
#  description = "The name of the default database in the RDS instance"
#  type        = string
#}
#
#variable "db_username" {
#  description = "The username for the master user in the RDS instance"
#  type        = string
#}
#
#variable "db_password" {
#  description = "The password for the master user in the RDS instance"
#  type        = string
#}
#
#variable "db_subnet_group_name" {
#  description = "The name of the DB subnet group where the RDS instance is deployed"
#  type        = string
#}
#
## variable "db_security_group_ids" {
##   description = "A list of security group IDs to associate with the RDS instance"
##   type        = list(string)
##   default     = [aws_security_group.this.id]
## }
#
#variable "db_security_group_names" {
#  description = "A list of security group names to associate with the RDS instance"
#  type        = list(string)
#}
#
#variable "allocated_storage" {
#  description = "The amount of storage to allocate for the RDS instance (in GB)"
#  type        = number
#}
#
#variable "engine" {
#  description = "The name of the database engine to use for the RDS instance"
#  type        = string
#}
#
#variable "engine_version" {
#  description = "The version of the database engine to use for the RDS instance"
#  type        = string
#}
#
#variable "instance_class" {
#  description = "The instance class to use for the RDS instance"
#  type        = string
#}
#
#variable "storage_type" {
#  description = "The storage type to use for the RDS instance (e.g., gp2, io1, standard)"
#  type        = string
#}
#
#variable "backup_retention_period" {
#  description = "The number of days to retain automated backups of the RDS instance"
#  type        = number
#}
#
#variable "db_parameter_group_name" {
#  description = "The name of the DB parameter group to associate with the RDS instance"
#  type        = string
#}
#
#variable "multi_az" {
#  description = "Whether to create a Multi-AZ deployment for the RDS instance"
#  type        = bool
#}
#
#variable "vpc_security_group_ids" {
#  description = "A list of VPC security group IDs to associate with the RDS instance"
#  type        = list(string)
#}
#
## # Set default values for optional variables
## /* variable "backup_retention_period" {
##   description = "The number of days to retain automated backups of the RDS instance"
##   type        = number
##   default     = 7
## } */
#
## /* variable "db_security_group_names" {
##   description = "A list of security group names to associate with the RDS instance"
##   type        = list(string)
##   default     = []
## } */
#
## /* variable "multi_az" {
##   description = "Whether to create a Multi-AZ deployment for the RDS instance"
##   type        = bool
##   default     = false
## } */
#
## /* variable "storage_type" {
##   description = "The storage type to use for the RDS instance (e.g., gp2, io1, standard)"
##   type        = string
##   default     = "gp2"
## }
##  */