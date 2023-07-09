output "redis_endpoint" {
  value = aws_memorydb_cluster.redis.cluster_endpoint
}