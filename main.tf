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

module "ec2-resources" {
  source = "./modules/ec2-resources"
  vpc_id = module.network-resources.vpc_id
  security_group_id = module.security-resources.jenkins_flask_sg.id
  public_subnet_id = module.network-resources.public_subnet_id
  #key_name = module.ec2_tls_key.key_name
}
