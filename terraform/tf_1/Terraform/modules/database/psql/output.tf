output "endpoint" {
  description = "O endpoint do banco de dados RDS"
  value       = aws_db_instance.example.endpoint
}

