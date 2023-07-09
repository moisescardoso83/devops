variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Uma lista de IDs de sub-rede para implantação das instâncias Redis"
}

variable "name" {
  type        = string
  description = "O nome do cluster Redis"
}

variable "num_nodes" {
  type        = number
  description = "O número de nós para o cluster Redis"
}

variable "node_type" {
  type        = string
  description = "O tipo de instância Redis para cada nó"
}

variable "engine_version" {
  type        = string
  #default     = "6.2"
  description = "Versao 6 do Redis"
}

#variable "user_names" {
#  type        = list(string)
#  #default     = []
#  description = "Uma lista de nomes de usuários para acessar o cluster Redis"
#}

#variable "passwords" {
#  type        = list(string)
#  #default     = []
#  description = "Uma lista de senhas correspondentes aos nomes de usuário definidos"
#}

#variable "acl_rules" {
#  type        = list(object({
#    name       = string
#    operation  = string
#    object_arn = string
#    pattern    = string
#  }))
#  #default     = []
#  description = "Uma lista de regras de ACL para o cluster Redis"
#}

variable "acl_rules" {
  type        = string
  description = "Regras de ACL #default para o cluster Redis"
}

variable "parameter_group" {
  type        = string
  description = "parameter_group #default para o cluster Redis"
}

variable "security_group_ids" {
  type        = list(string)
  #default     = ["sg-0dc5c35f98aa76183"]
  description = "security_group #default para o cluster Redis"
}

variable "subnet_group_name" {
  type        = string
  #default     = "snet-01"
  description = "security_group #default para o cluster Redis"
}




data "aws_subnet_ids" "filtered_subnets" {
  vpc_id = var.vpc_id

  filter {
   name  = "availability-zone"
   values = ["us-east-1a","us-east-1b","us-east-1d"]

 }
tags = {
    Name = "*priv*"
  }

}