resource "tls_private_key" "rsa_4096" {
algorithm = "RSA"
rsa_bits = 4096
}

#variable "key_name" {}

 #Create a Key Pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_pem"
 public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
 content = tls_private_key.rsa_4096.private_key_pem
 filename = "ec2_pem"
}
