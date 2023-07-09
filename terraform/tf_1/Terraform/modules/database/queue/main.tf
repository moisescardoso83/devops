resource "aws_mq_broker" "this" {
  broker_name              = var.broker_name
  deployment_mode          = var.deployment_mode
  engine_type              = var.engine_type
  engine_version           = var.engine_version
  host_instance_type       = var.instance_type
  subnet_ids               = [var.subnet_ids]
  security_groups          = [aws_security_group.mq-sg.id]

  logs {
    general = true
  }
  user {
    username = "rabbitmquser"
    password = "RabbitMQuserNicePassword"
  }

}


resource "aws_security_group_rule" "rabbitmq_ingress" {
  type        = "ingress"
  from_port   = 5672
  to_port     = 5672
  protocol    = "tcp"
  security_group_id = aws_security_group.mq-sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rabbitmq_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  security_group_id = aws_security_group.mq-sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "mq-sg" {
  name        = "rabbitmq-sg"
  description = "Allow TLS and HTTP inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Rabbitmq"
  }
}