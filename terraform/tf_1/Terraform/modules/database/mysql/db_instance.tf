resource "aws_db_instance" "this" {
  identifier              = var.db_instance_identifier
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                  = var.db_instance_identifier
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  parameter_group_name = aws_db_parameter_group.dbpg.name
  multi_az                = var.multi_az
  storage_type            = var.storage_type
  #backup_retention_period = var.backup_retention_period
  skip_final_snapshot = true

  tags = {
    Name = var.db_instance_identifier
  }

  depends_on = [
    aws_security_group.this,
    aws_db_subnet_group.this
  ]
}

