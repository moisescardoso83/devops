
#data "template_file" "this" {
#   template = file("./templates/image.json")

#  vars = {
#    container_name = var.container_name
#    app_image      = var.app_image
#    app_port       = var.app_port
#    fargate_cpu    = var.fargate_cpu
#    fargate_memory = var.fargate_memory
#    aws_region     = var.aws_region
#  }
#}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_name
  execution_role_arn       = var.execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  #container_definitions    = data.template_file.this.rendered
  container_definitions = jsonencode([
    {
      name      = "test"
      image     = "nginx"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = var.subnet_ids_pvt
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = var.container_name
    container_port   = var.app_port
  }

}


resource "aws_alb_target_group" "this" {
  name = "test"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  #health_check = "${var.lb_health_check}"

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.loadbalancer_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}