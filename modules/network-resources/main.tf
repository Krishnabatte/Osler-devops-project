resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "default_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = var.vpc_id
  cidr_block = "00.0.0.0/0"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}
