### VPC ###

resource "aws_vpc" "eddiecorp_eks_vpc" {
  cidr_block           = var.eddiecorp_eks_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "eddiecorp_eks_vpc"
  }
}


### IGW ###

resource "aws_internet_gateway" "eddiecorp_eks_igw" {
  vpc_id = aws_vpc.eddiecorp_eks_vpc.id
  tags = {
    Name = "eddiecorp_eks_igw"
  }
}


### SUBNET ###

resource "aws_subnet" "eddiecorp_eks_subnet_a" {
  vpc_id                  = aws_vpc.eddiecorp_eks_vpc.id
  cidr_block              = var.eddiecorp_eks_subnet_a_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "eddiecorp_eks_subnet_a"
  }
}

resource "aws_subnet" "eddiecorp_eks_subnet_b" {
  vpc_id                  = aws_vpc.eddiecorp_eks_vpc.id
  cidr_block              = var.eddiecorp_eks_subnet_b_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "eddiecorp_eks_subnet_b"
  }
}

resource "aws_subnet" "eddiecorp_eks_subnet_c" {
  vpc_id                  = aws_vpc.eddiecorp_eks_vpc.id
  cidr_block              = var.eddiecorp_eks_subnet_c_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "eddiecorp_eks_subnet_c"
  }
}


### ROUTE TABLE ###

resource "aws_default_route_table" "eddiecorp_eks_rt" {
  default_route_table_id = aws_vpc.eddiecorp_eks_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eddiecorp_eks_igw.id
  }
  tags = {
    Name = "eddiecorp_eks_rt"
  }
}