resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.eks_settings.cluster_name}_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.eks_settings.cluster_name}_igw"
  }
}

resource "aws_default_route_table" "main_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.eks_settings.cluster_name}_rt"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block,2,0)}"
  ipv6_cidr_block         = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block,8,0)}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true
  tags = {
    Name                             = "${var.eks_settings.cluster_name}_subnet_a"
    "kubernetes.io/cluster/${var.eks_settings.cluster_name}" = "owned"
    "kubernetes.io/role/elb"         = "1"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block,2,1)}"
  ipv6_cidr_block         = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block,8,1)}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true
  tags = {
    Name                             = "${var.eks_settings.cluster_name}_subnet_b"
    "kubernetes.io/cluster/${var.eks_settings.cluster_name}" = "owned"
    "kubernetes.io/role/elb"         = "1"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block,2,2)}"
  ipv6_cidr_block         = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block,8,2)}"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true
  tags = {
    Name                             = "${var.eks_settings.cluster_name}_subnet_c"
    "kubernetes.io/cluster/${var.eks_settings.cluster_name}" = "owned"
    "kubernetes.io/role/elb"         = "1"
  }
}