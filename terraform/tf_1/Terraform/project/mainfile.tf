#Criação da VPC
module "vpc" {
  source = "../modules/vpc"
  region = ["us-east-1a", "us-east-1b", "us-east-1d"]
  tag_environment = var.environment[terraform.workspace]
  cidr_block = var.vpc_cdr[terraform.workspace]
}

module "eks-cluster" {
  source = "../modules/eks"
  cluster-name = "eks-${var.environment[terraform.workspace]}"
  desired_size   = "2"
  instance_types = ["t3.medium"]
  subnet_ids = module.vpc.subnet_ids_private
  min_size = "1"
  max_size = "10"
  tag_environment = var.environment[terraform.workspace]
}

#Criação do Cluster de Redis
#module "redis" {
#  source = "../modules/database/memorydb"
#  acl_rules = "open-access"
#  engine_version = "6.2"
#  # Verificar criação do nome
#  name = "redis-02"
#  node_type = "db.t4g.small"
#  num_nodes = 1
#  parameter_group = "default.memorydb-redis6"
#  region = "us-east-1"
#  security_group_ids = []
#  subnet_group_name = ""
#  subnet_ids = module.vpc.subnet_ids_private
#  vpc_id = module.vpc.vpc_id
#  depends_on = [
#    module.vpc
#  ]
#}

#Criação do Cluster de Mysql, removido ja que foi migrado para Aurora
#module "mysql" {
#  source = "../modules/database/mysql"
#  allocated_storage = "20"
#  db_instance_identifier = "testepoc1"
#  db_password = "mysql-Feb252023"
##  db_security_group_ids = []
##  db_subnet_group_name = ""
#  db_username = "mysqlpoc"
#  engine = "mysql"
#  engine_version = "8.0.28"
#  instance_class = "db.m6i.large"
#  multi_az = false
#  region = "us-east-1"
#  storage_type = "gp3"
#  vpc_id = module.vpc.vpc_id
#  vpc_security_group_ids = []
#  subnet_ids = module.vpc.subnet_ids_private
#}

#Criação do Cluster de Aurora
#module "aurora-serverless" {
#  source = "../modules/database/aurora-serverless"
#  cluster_identifier              = "database-2"
#  engine                          = "aurora-mysql"
#  engine_version                  = "8.0.mysql_aurora.3.03.0"
#  availability_zones              = ["us-east-1b", "us-east-1c", "us-east-1f"]
#  database_name                   = "banco_inicial"
#  master_username                 = "admin"
#  master_password                 = "null"
#  backup_retention_period         = 5
#  preferred_backup_window         = "07:00-09:00"
#  copy_tags_to_snapshot           = true
#  db_cluster_parameter_group_name = "default.aurora-mysql8.0"
#  db_subnet_group_name            = "default-vpc-00b0a77fe38971d9a"
#  deletion_protection             = false
#  enabled_cloudwatch_logs_exports    = ["audit","error","general","slowquery"]
#  serverlessv2_scaling_configuration = [{
#    max_capacity = 2
#    min_capacity = 1
#  }]
#  skip_final_snapshot                = true
#  vpc_security_group_ids             = ["sg-0ba40080a0f18096d"]
#}
#
##Criação do Cluster de RabbitMq
#module "rabbitmq" {
#  source = "../modules/database/queue"
#  broker_name        = "rabbitmq"
#  deployment_mode    = "SINGLE_INSTANCE"
#  engine_type        = "RabbitMQ"
#  engine_version     = "3.8.6"
#  instance_type      = "mq.t3.micro"
#  #ecurity_group_ids = ["sg-00d1a552ca069aa4e"]
#  subnet_ids         = module.vpc.subnet_ids_private[0]
#  vpc_id = module.vpc.vpc_id
#}

#####   NOT APPLICABLE ####
#Criação do Cluster de ECS
#module "ecs" {
#  source = "../modules/ecsCluster/ecs"
#  ecs_cluster_name = "test"
#  tag_environment = "POC"
#  vpc_id = module.vpc.vpc_id
#}

#Criação das roles e regras para o ECS cluster e Tasks
#module "ecs_essentials" {
#  source = "../modules/ecsCluster/iam"
#}

#Criação do Proxy ALB da AWS para comunicação com os containers
#module "alb" {
#  source = "../modules/loadbalancer/ALB"
#  vpc_id = module.vpc.vpc_id
#  tag_environment = "POC"
#  subnets = module.vpc.subnet_ids_public
#
#}

#Criação de proxy interno para comunicação entre aplicações dentro da VPC mas fora do ECS cluster
#module "nlb" {
#  source = "../modules/loadbalancer/NLB"
#  vpc_id = module.vpc.vpc_id
#  tag_environment = "POC"
#  subnets = module.vpc.subnet_ids_private
#
#}

#Criação de um container, TaskDefinition
#module "task_test" {
#  source = "../modules/ecsCluster/service"
#  task = module.ecs_essentials.taskrole
#  execution_role = module.ecs_essentials.taskrole
#  #vpc_name = module.ecs.name
#  vpc_id = module.vpc.vpc_id
#  tag_environment = "POC"
#  subnet_ids_pvt = module.vpc.subnet_ids_private
#  subnet_ids_pub = module.vpc.subnet_ids_public
#  container_name = "test"
#  service_name = "test"
#  task_name = "test"
#  ecs_cluster_name = module.ecs.name
#  fargate_memory = 512
#  fargate_cpu = 256
#  app_count = 1
#  app_port = 80
#  app_image = "nginx"
#  loadbalancer_arn = module.alb.aws_alb
#  loadbalancer_sg_id = module.alb.aws_alb_sg_id
#}