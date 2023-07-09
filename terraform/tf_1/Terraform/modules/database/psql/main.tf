resource "aws_db_subnet_group" "example" {
  name       = "example"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "example" {
  name_prefix = "example"
}

resource "aws_db_instance" "example" {
  identifier            = "example"
  engine                = "postgres"
  engine_version        = var.engine_version
  instance_class        = var.instance_type
  allocated_storage     = var.allocated_storage
  storage_type          = "gp2"
  username              = var.username
  password              = var.password
  db_subnet_group_name   = aws_db_subnet_group.example.name
  vpc_security_group_ids = [aws_security_group.example.id]
}

