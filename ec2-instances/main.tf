resource "aws_instance" "webserver-ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "web_server-ec2"
  }
user_data = <<-EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}
