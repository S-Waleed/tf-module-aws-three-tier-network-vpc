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

# Add an internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

# Add route to the internet gateway
resource "aws_route" "internet" {
  route_table_id            = aws_vpc.this.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.this.id

  depends_on                = [aws_internet_gateway.this]
}

# NACLs
# Public NACLS
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id
  subnet_ids = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  # Ingress rules
  # Allow all local traffic
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow HTTPS traffic from the internet
  ingress {
    protocol   = "6"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Egress rules
  # Allow all ports, protocols, and IPs outbound
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.vpc_name}-public-nacl"
  }

  depends_on = [ aws_subnet.public ]
}

# Private NACL
# Tag the default nacl
# Update routes on the default nacl

resource "aws_default_network_acl" "private" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  # Ingress rules
  # Allow all local traffic
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Egress rules
  # Allow all ports, protocols, and IPs outbound
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.vpc_name}-private-nacl"
  }
}

# Security Groups
# default_security_group_id

# Enhancements
#  Endpoints

# Charges may occur

# Reserve EIPs
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.vpc_name}-eip-nat"
  }

  depends_on = [aws_internet_gateway.this]

}

# NAT Gateway
resource "aws_nat_gateway" "zone_a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gateway-aza"
  }

  depends_on = [aws_internet_gateway.this, aws_subnet.public]
}

resource "aws_nat_gateway" "zone_b" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id

  tags = {
    Name = "${var.vpc_name}-nat-gateway-azb"
  }

  depends_on = [aws_internet_gateway.this, aws_subnet.public]
}
