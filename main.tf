# Create the VPC
resource "aws_vpc" "this" {
  cidr_block            = var.vpc_cidr
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = merge(
    var.additional_tags,
    {
      Name = var.vpc_name
    }
  )
}

# Create a route table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.vpc_name}-route-table"
    }
  )
}

# Create the public subnets
resource "aws_subnet" "public_zone_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_zone_a_subnet_cidr
  availability_zone       = "a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public_zone_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_zone_b_subnet_cidr
  availability_zone       = "b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}
