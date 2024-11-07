# Output the public IP of the EC2 instance
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2-resources.public_ip
}

# Output the Flask URL
output "flask_url" {
  description = "Flask Web Server URL"
  value       = "http://${module.ec2-resources.public_ip}:5000"
}

# Output the Jenkins URL
output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${module.ec2-resources.public_ip}:8080"
}

output "public_subnet_id" {
  value = module.subnets.public_subnet_id
}


