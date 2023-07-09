## ALB Security Group: Edit to restrict access to the application
#resource "aws_security_group" "alb-sg" {
#  name   = "${var.container_name}-alb-sg"
#  vpc_id = var.vpc_id
#
#  ingress {
#    protocol    = "tcp"
#    from_port   = var.app_port
#    to_port     = var.app_port
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    protocol    = "-1"
#    from_port   = 0
#    to_port     = 0
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_sg" {
  name   = "${var.container_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [var.loadbalancer_sg_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

