module "network-resources" {
  source = "./modules/network-resources"
  vpc_id = module.network-resources.vpc_id
}

module "security-resources" {
  source = "./modules/security-resources"
  vpc_id = module.network-resources.vpc_id
}

module "tls-private-key" {
source = "./modules/tls-private-key"
key_name = "my-ec2-instance-key"
}

resource "tls_private_key" "rsa_4096" {
algorithm = "RSA"
rsa_bits = 4096
}

variable "key_name" {}

 #Create a Key Pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
 public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
 content = tls_private_key.rsa_4096.private_key_pem
 filename = var.key_name
}

module "ec2-resources" {
  source = "./modules/ec2-resources"
  vpc_id = module.network-resources.vpc_id
  security_group_id = module.security-resources.security_group_id
  public_subnet_id = module.network-resources.public_subnet_id
 }
