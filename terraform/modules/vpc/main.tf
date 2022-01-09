resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.Application}"
  }
}
data "aws_availability_zones" "available" {}
#################################################
###########             subnets         #########
#################################################
resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index}"
  }
}
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "public-subnet-${count.index}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Application}-igw"
  }
}
resource "aws_eip" "nat_ip" {
  vpc = true
  tags = {
    Name = "${var.Application}-ip"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.Application}-nat"
  }
  depends_on = [aws_internet_gateway.igw]
}
#################################################
###########           Routes            #########
#################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.Application}-public-rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.Application}-private-rt"
  }
}
#################################################
#######         Security Groups         #########
#################################################
resource "aws_security_group" "vpce_sg" {
  name        = "vpce_sg"
  description = "Allow Access to VPCE"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpce_sg"
  }
}
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound traffic to alb_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from World"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP from World"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.Application}_alb_sg"
  }
}
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow HTTP from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from VPC"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.Application}_ecs_sg"
  }
}
#################################################
###########           endpoints         #########
#################################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name = "${var.Application}-S3-VPC-Endpoint"
  }
  route_table_ids = [aws_route_table.private_rt.id]
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  tags = {
    Name = "${var.Application}-ecr-dkr-Endpoint"
  }
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  tags = {
    Name = "${var.Application}-ecr-api-Endpoint"
  }
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  tags = {
    Name = "${var.Application}-logs-Endpoint"
  }
  private_dns_enabled = true
}

