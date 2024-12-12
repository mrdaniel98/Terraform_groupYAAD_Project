terraform {
  backend "s3" {
    bucket  = "finalprojects3team"
    key     = "terraform/state"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "ProjectVPC" })
}

resource "aws_subnet" "public_subnets" {
  for_each                = zipmap([for i, v in var.public_subnets : i], var.public_subnets)
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "PublicSubnet-${each.key}" })
}

resource "aws_subnet" "private_subnets" {
  for_each          = zipmap([for i, v in var.private_subnets : i], var.private_subnets)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = merge(var.tags, { Name = "PrivateSubnet-${each.key}" })
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags   = merge(var.tags, { Name = "ProjectIGW" })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  tags   = merge(var.tags, { Name = "PublicRouteTable" })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_igw.id
}

resource "aws_route_table_association" "public_subnet_associations" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_gw_eip" {
  vpc  = true
  tags = merge(var.tags, { Name = "NATGatewayEIP" })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnets["0"].id
  tags          = merge(var.tags, { Name = "NATGateway" })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  tags   = merge(var.tags, { Name = "PrivateRouteTable" })
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_subnet_associations" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}
