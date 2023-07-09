output "instance_public_ip" {
  description = "O endereço IP público da instância"
  value       = aws_instance.example.public_ip
}

