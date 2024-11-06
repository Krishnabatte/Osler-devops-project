# Define a Security Group to allow necessary traffic
resource "aws_security_group" "jenkins_flask_sg" {
  name        = "jenkins_flask_sg"
  description = "Allow SSH, HTTP, and Jenkins"
															  
  # Inbound rules for SSH
  ingress {
    from_port   = 22                                            
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (adjust this for security)
  }

  # Inbound rule for Flask (Port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Flask from anywhere
  }

  # Inbound rule for Jenkins (Port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Jenkins UI from anywhere
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_flask_sg"
  }
}
