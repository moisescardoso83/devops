variable "region" {
  description = "A região da AWS onde o RDS será criado"
  type        = string
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "IDs das sub-redes do RDS"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "O tipo de instância do RDS"
  type        = string
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  description = "O tamanho do disco em GB"
  type        = number
  default     = 10
}

variable "engine_version" {
  description = "A versão do PostgreSQL"
  type        = string
  default     = "13.2"
}

variable "username" {
  description = "O nome de usuário do banco de dados"
  type        = string
  default     = "example"
}

variable "password" {
  description = "A senha do banco de dados"
  type        = string
  default     = "password"
}

