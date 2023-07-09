resource "aws_elasticache_subnet_group" "example" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "example" {
  engine           = "redis"
  engine_version   = var.engine_version
  cluster_name     = var.name
  node_type        = var.node_type
  num_cache_clusters = var.num_cache_clusters
  az_mode          = var.az_mode

  security_group_ids = var.security_group_ids

  subnet_group_name = aws_elasticache_subnet_group.example.name
}

resource "aws_elasticache_parameter_group" "example" {
  name   = "${var.name}-parameter-group"
  family = "redis5.0"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "maxmemory-policy"
    value = "volatile-lru"
  }
}

resource "aws_elasticache_replication_group" "example" {
  replication_group_id = "${var.name}-replication-group"
  replication_group_description = "Replication group for ${var.name}"

  node_group {
    node_group_id         = "primary"
    primary_availability_zone = var.subnet_ids[0]
    replicas_per_node_group = var.num_cache_clusters - 1

    cache_node_type = var.node_type

    subnet_group_name = aws_elasticache_subnet_group.example.name
  }

  parameter_group_name = aws_elasticache_parameter_group.example.name

  security_group_ids = var.security_group_ids
}

resource "aws_elasticache_replication_group" "example_read_replica" {
  replication_group_id = "${var.name}-read-replica-group"
  replication_group_description = "Read replica group for ${var.name}"

  node_group {
    node_group_id = "read-replica"
    replicas_per_node_group = var.num_cache_clusters

    cache_node_type = var.node_type

    subnet_group_name = aws_elasticache_subnet_group.example.name
  }

  parameter_group_name = aws_elasticache_parameter_group.example.name

  security_group_ids = var.security_group_ids
}

resource "aws_security_group_rule" "redis_ingress" {
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = var.security_group_ids[0]

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "redis_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = var.security_group_ids[0]

  cidr_blocks = ["0.0.0.0/0"]
}

