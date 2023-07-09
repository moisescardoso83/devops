


resource "aws_db_subnet_group" "this" {
  name        = var.db_instance_identifier
  description = "Subnet group para RDS MySQL"
  subnet_ids  = var.subnet_ids
  #subnet_ids = var.subnet_ids
  tags = {
    Name = var.db_instance_identifier
  }
#
#  depends_on = [data.aws_subnet.subnets-list]
}



#data "aws_subnet_ids" "private" {
#  vpc_id = var.vpc_id
#}
#
#resource "aws_subnet" "private" {
#  count = length(data.aws_availability_zones.available.names)
#
##  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index + 4)
#  vpc_id     = var.vpc_id
##  map_public_ip_on_launch = false
#  availability_zone = data.aws_availability_zones.available.names[count.index]
#
#  tags = {
#    Name = "private-${count.index}"
#  }
#}

#data "aws_subnets" "subnets" {
#  filter {
#    name   = "vpc-id"
#    values = [var.vpc_id]
#  }
#}
#
#data "aws_subnet" "subnets-list" {
#  for_each = toset(data.aws_subnets.subnets.ids)
#  id       = each.value
#}

#output "subnet_cidr_blocks" {
#  value = [for s in data.aws_subnet.subnets-list : s.cidr_block]
#}
