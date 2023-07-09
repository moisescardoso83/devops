variable "aws_region" {
    default = "us-east-1"
    type = string
  
}

variable "app_image" {
    type = string    
    description = "Image ECR"
  
}

variable "app_port" {
    description = "ECS Container Port"
    type = string  
  
}

variable "app_count" {
    type = string 
  
}

variable "health_check_path" {
    default = "/"
  
}

variable "fargate_cpu" {
    description = "CPU ECS Fargate"
    type    = string
  
}
variable "fargate_memory" {
    description = "Memory ECS Fargate"
    type = string 
  
}

variable "ecs_cluster_name" {
    default = "Name Cluster"
    type = string 
  
}

variable "task_name" {
    description = "Name Task"
    type = string 
  
}
variable "service_name" {
    description = "Name Service"
    type = string 
  
}

variable "container_name" {
    description = "Name Container"
    type = string 
  
}

variable "subnet_ids_pvt" {
    description = "List subnets private"
    type = list
  
}
variable "subnet_ids_pub" {
    description = "List subnets publics"
    type = list
  
}
variable "vpc_id" {
    description = "ID VPC"
    type = string 
  
}

variable "tag_environment" {
    description = "Environment Tag"
    type = string    
  
}

variable "task" {
    description = "Task arn role"
    type = string

}

variable "execution_role" {
    description = "Task Execution arn role"
    type = string

}

variable "loadbalancer_arn" {
    description = "Load Balancer Arn"
    type = string

}

variable "loadbalancer_sg_id" {
    description = "Load Balancer SG ID"
    type = string

}