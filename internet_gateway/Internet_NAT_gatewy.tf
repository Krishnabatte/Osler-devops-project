resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = { Name = "main_igw" }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public_route_table" }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
