resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = { Name = "main_igw" }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public_route_table" }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public_route_table.id
}

# Output the IGW ID
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
