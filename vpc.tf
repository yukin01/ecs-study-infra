locals {
  cidr_block = "10.0.0.0/16"
  public_subnets = {
    public-a = { cidr_block = "10.0.1.0/24", availability_zone = "ap-northeast-1a" }
    public-c = { cidr_block = "10.0.2.0/24", availability_zone = "ap-northeast-1c" }
  }
  private_subnets = {
    private-a = { cidr_block = "10.0.11.0/24", availability_zone = "ap-northeast-1a" }
    private-c = { cidr_block = "10.0.12.0/24", availability_zone = "ap-northeast-1c" }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "fargate-study"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "ap-northeast-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "public" {
  for_each          = local.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table_association" "igw" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.igw.id
}


resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public["public-a"].id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "nat" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.nat.id
}
