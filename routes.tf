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

# Create a route table for the web subnets
# Uses NAT gateway
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

# Associate these subnets with the private route table
resource "aws_route_table_association" "web" {
  count = length(var.web_subnet_cidrs)

  subnet_id      = element(aws_subnet.web.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app" {
  count = length(var.app_subnet_cidrs)

  subnet_id      = element(aws_subnet.app.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "data" {
  count = length(var.data_subnet_cidrs)

  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_route_table.data.id
}
