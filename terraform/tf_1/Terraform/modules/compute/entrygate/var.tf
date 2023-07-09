variable "region" {
  description = "A região da AWS onde a instância será criada"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "O tipo de instância"
  type        = string
  default     = "t3.medium"
}

variable "image_id" {
  description = "O ID da imagem da AMI"
  type        = string
  default     = "ami-08fdec01f5df9998f"
}

variable "key_name" {
  description = "O nome da chave SSH para acessar a instância"
  type        = string
}

variable "security_group_ids" {
  description = "IDs dos grupos de segurança para a instância"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "ID da sub-rede para a instância"
  type        = string
}

variable "user_data" {
  description = "O script de inicialização da instância"
  type        = string
}

variable "name" {
  description = "O nome da instância"
  type        = string
}

variable "spot_price" {
  description = "O preço máximo da instância no mercado spot"
  type        = string
  default     = "0.1"
}

