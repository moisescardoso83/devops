# network.tf
resource "aws_vpc" "this" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = {
    Enviroment = var.tag_environment
    Name = var.tag_environment
  }  
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"

}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  #availability_zone = var.region
  vpc_id            = aws_vpc.this.id

  tags = {
    Enviroment = var.tag_environment
    Name = "priv-${var.tag_environment}"
    "kubernetes.io/cluster/eks-${var.tag_environment}"= "shared"

  }  
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true

  tags = {
    Enviroment = var.tag_environment
    Name = "pub-${var.tag_environment}"
    "kubernetes.io/role/elb" =  "1"
    "kubernetes.io/cluster/eks-${var.tag_environment}"= "owned"
  }   
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Enviroment = var.tag_environment
    Name = var.tag_environment
  }  
}

# Route the public subnet traffic through the IGW
resource "aws_route" "this" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "this" {
  #count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  #count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, 0)
  allocation_id = aws_eip.this.id
  #element(aws_eip.this.*.id, count.index)
  tags = {
    Enviroment = var.tag_environment
    Name = var.tag_environment
  }
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }

}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
