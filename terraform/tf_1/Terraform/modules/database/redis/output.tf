output "endpoint" {
  description = "O endpoint do cluster Redis"
  value       = aws_elasticache_cluster.example.configuration_endpoint_address
}

