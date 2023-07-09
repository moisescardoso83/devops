variable "region" {
  description = "A região da AWS onde o cluster será criado"
  type        = string
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "IDs das sub-redes para os nós do cluster Redis"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos grupos de segurança para o cluster Redis"
  type        = list(string)
}

variable "name" {
  description = "O nome do cluster Redis"
  type        = string
}

variable "node_type" {
  description = "O tipo de instância dos nós do cluster Redis"
  type        = string
  default     = "cache.t3.small"
}

variable "engine_version" {
  description = "A versão do Redis"
  type        = string
  default     = "5.0.6"
}

variable "num_cache_clusters" {
  description = "O número de nós do cluster Redis"
  type        = number
  default     = 1
}

variable "az_mode" {
  description = "O modo de zona de disponibilidade do cluster Redis"
  type        = string
  default     = "single-az"
}

