provider "aws" {
  region = "us-east-1"
}

resource "aws_memorydb_cluster" "redis" {
  name                 = var.name
  acl_name             = var.acl_rules
  node_type            = var.node_type
  parameter_group_name = var.parameter_group
  security_group_ids   = var.security_group_ids
  engine_version       = var.engine_version
  #subnet_group_name    = var.subnet_group_name
  subnet_group_name  = aws_memorydb_subnet_group.redis.name
}

resource "random_password" "redis" {
  length = 16
}

resource "random_pet" "suffix" {}

resource "aws_memorydb_user" "redis" {
  user_name     = format("my-user-%s", random_pet.suffix.id)
  access_string = "on ~* &* +@all"

  authentication_mode {
    type      = "password"
    passwords = [random_password.redis.result]
  }
}

resource "aws_memorydb_acl" "redis" {
  name        = "${var.name}-redis-acl"
  user_names  = [aws_memorydb_user.redis.user_name]
}

resource "aws_security_group" "redis" {
  name_prefix = "${var.name}-redis-sg-"
}

resource "aws_memorydb_subnet_group" "redis" {
  name       = "${var.name}-redis-subnet-group"
  subnet_ids = data.aws_subnet_ids.filtered_subnets.ids

}

resource "aws_memorydb_parameter_group" "redis" {
  name   = "${var.name}-pg"
  family = "memorydb_redis6"
  parameter {
    name  = "activedefrag"
    value = "yes"
  }
  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}