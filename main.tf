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

# Tag the main route table
resource "aws_ec2_tag" "main_route_table" {
  resource_id = aws_vpc.this.main_route_table_id
  key         = "Name"
  value       = "${var.vpc_name}-route-table"
}

# Create the public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${var.zones[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-${var.zones[count.index]}"
  }
}

# Create the web subnets
resource "aws_subnet" "web" {
  count = length(var.web_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.web_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${var.zones[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-web-subnet-${var.zones[count.index]}"
  }
}

# Create the application subnets
resource "aws_subnet" "app" {
  count = length(var.app_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.app_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${var.zones[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-app-subnet-${var.zones[count.index]}"
  }
}

# Create the database subnets
resource "aws_subnet" "data" {
  count = length(var.data_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.data_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${var.zones[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-data-subnet-${var.zones[count.index]}"
  }
}

# Associate the subnets with the route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_vpc.this.main_route_table_id
}

resource "aws_route_table_association" "web" {
  count = length(var.web_subnet_cidrs)

  subnet_id      = element(aws_subnet.web.*.id, count.index)
  route_table_id = aws_vpc.this.main_route_table_id
}

resource "aws_route_table_association" "app" {
  count = length(var.app_subnet_cidrs)

  subnet_id      = element(aws_subnet.app.*.id, count.index)
  route_table_id = aws_vpc.this.main_route_table_id
}

resource "aws_route_table_association" "data" {
  count = length(var.data_subnet_cidrs)

  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_vpc.this.main_route_table_id
}

# NACLs
# Tag the default nacl
# Update routes on the default nacl

# Security Groups
