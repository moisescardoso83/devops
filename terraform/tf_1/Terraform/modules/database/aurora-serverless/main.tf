resource "aws_rds_cluster" "aurora-01" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  copy_tags_to_snapshot   = true
  db_cluster_parameter_group_name    = var.db_cluster_parameter_group_name
  db_subnet_group_name               = var.db_subnet_group_name
  deletion_protection                = var.deletion_protection
  enabled_cloudwatch_logs_exports    = var.enabled_cloudwatch_logs_exports
#  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  skip_final_snapshot                = var.skip_final_snapshot
#  vpc_security_group_ids             = [var.vpc_security_group_ids]
}