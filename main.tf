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
key_name = "ec2_pem"
}

# Call Internet Gateway module
module "internet_gateway" {
  source = "./modules/internet_gateway"
  public_subnet_id = module.network-resources.public_subnet_id
  vpc_id = module.network-resources.vpc_id
}

module "ec2-resources" {
  source = "./modules/ec2-resources"
  key_name = module.tls-private-key.key_name
  vpc_id = module.network-resources.vpc_id
  security_group_id = module.security-resources.security_group_id
  public_subnet_id = module.network-resources.public_subnet_id
 }
