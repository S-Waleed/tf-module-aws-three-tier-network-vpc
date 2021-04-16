# Tag the main route table
resource "aws_ec2_tag" "main_route_table" {
  resource_id = aws_vpc.this.main_route_table_id
  key         = "Name"
  value       = "${var.vpc_name}-main-route-table"
}

# Create route table for the public subnets
# Uses IG
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create a route table for the web and app subnets in AZ A
# Uses NAT gateway in AZ A
resource "aws_route_table" "private_aza" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.zone_a.id
  }

  tags = {
    Name = "${var.vpc_name}-private-route-table-aza"
  }

  depends_on = [
    aws_nat_gateway.zone_a
  ]
}

# Create a route table for the web and app subnets in AZ B
# Uses NAT gateway in AZ B
resource "aws_route_table" "private_azb" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.zone_b.id
  }

  tags = {
    Name = "${var.vpc_name}-private-route-table-azb"
  }

  depends_on = [
    aws_nat_gateway.zone_b
  ]
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-data-route-table"
  }
}

# Associate these subnets with the private route tables accordingly
resource "aws_route_table_association" "web_aza" {
  subnet_id      = aws_subnet.web[0].id
  route_table_id = aws_route_table.private_aza.id
}

resource "aws_route_table_association" "app_aza" {
  subnet_id      = aws_subnet.app[0].id
  route_table_id = aws_route_table.private_aza.id
}

resource "aws_route_table_association" "web_azb" {
  subnet_id      = aws_subnet.web[1].id
  route_table_id = aws_route_table.private_azb.id
}

resource "aws_route_table_association" "app_azb" {
  subnet_id      = aws_subnet.app[1].id
  route_table_id = aws_route_table.private_azb.id
}

resource "aws_route_table_association" "data" {
  count = length(var.data_subnet_cidrs)

  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_route_table.data.id
}
