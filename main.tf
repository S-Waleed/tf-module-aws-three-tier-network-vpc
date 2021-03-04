# Create the VPC
resource "aws_vpc" "this" {
  cidr_block            = var.vpc_cidr
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.vpc_name}-vpc"
    }
  )
}

# Create the route table
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
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_zone_a_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-a"
  }
}

resource "aws_subnet" "public_zone_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_zone_b_subnet_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-b"
  }
}

resource "aws_subnet" "web_zone_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.web_zone_a_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-web-subnet-a"
  }
}

resource "aws_subnet" "web_zone_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.web_zone_b_subnet_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-web-subnet-b"
  }
}

resource "aws_subnet" "app_zone_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.app_zone_a_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-app-subnet-a"
  }
}

resource "aws_subnet" "app_zone_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.app_zone_b_subnet_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-app-subnet-b"
  }
}

resource "aws_subnet" "data_zone_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.data_zone_a_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-data-subnet-a"
  }
}

resource "aws_subnet" "data_zone_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.data_zone_b_subnet_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-data-subnet-b"
  }
}

# Associate the subnets with the route table

# Set as main route table

# NACLs

# Security Groups
