resource "aws_security_group" "this" {
  name_prefix = "rds-mysql-sg-"
  description = "Security group for RDS MySQL"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}
