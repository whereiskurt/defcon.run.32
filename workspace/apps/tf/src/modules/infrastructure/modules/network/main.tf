resource "aws_vpc" "vpc" {
  provider             = aws.app
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({ Name = "${var.label}-vpc" }, var.network_tags)
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "ig" {
  provider = aws.app
  vpc_id   = aws_vpc.vpc.id
  tags     = merge({ Name = "${var.label}-igw" }, var.network_tags)
}

# NAT Gateway needs an EIP
resource "aws_eip" "nat" {
  provider = aws.app
  domain   = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  provider      = aws.app
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0) # Example uses the first public subnet
  tags          = merge({ Name = "${var.label}-nat-gw" }, var.network_tags)
}

# Routes for NAT Gateway in private route table
resource "aws_route" "private_nat_gateway" {
  provider               = aws.app
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "public_igw" {
  provider               = aws.app
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Rest of your resources
resource "aws_subnet" "public_subnet" {
  provider                = aws.app
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  //map_public_ip_on_launch = true
  tags                    = { Name = "${var.label}-public-${element(var.availability_zones, count.index)}" }
}

resource "aws_subnet" "private_subnet" {
  provider                = aws.app
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.label}-private-${element(var.availability_zones, count.index)}" }
}

resource "aws_route_table" "private" {
  provider = aws.app
  vpc_id   = aws_vpc.vpc.id
  tags     = merge({ Name = "${var.label}-private" }, var.network_tags)
}

resource "aws_route_table" "public" {
  provider = aws.app
  vpc_id   = aws_vpc.vpc.id
  tags     = merge({ Name = "${var.label}-public" }, var.network_tags)
}

resource "aws_route_table_association" "public" {
  provider       = aws.app
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  provider       = aws.app
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
