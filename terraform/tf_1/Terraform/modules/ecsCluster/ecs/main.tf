# ecs cluster
resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Enviroment = var.tag_environment      
  }  
}

# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${aws_ecs_cluster.this.name}"
  retention_in_days = 30

  tags = {
    Enviroment = var.tag_environment
  }
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "${aws_ecs_cluster.this.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "ecs.${var.ecs_cluster_name}"
  description = "Discovery for cluster ${var.ecs_cluster_name}"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "this" {
  name = "ecs.${var.ecs_cluster_name}"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}