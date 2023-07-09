#in this template we are creating aws application loadbalancer and target group and alb http listener

resource "aws_lb" "this" {
  name            = "${var.tag_environment}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets         = var.subnets
}
