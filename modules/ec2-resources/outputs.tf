# Output the public IP of the EC2 instance
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins_flask_instance.public_ip
}

# Output the Flask URL
output "flask_url" {
  description = "Flask Web Server URL"
  value       = "http://${aws_instance.jenkins_flask_instance.public_ip}:5000"
}

# Output the Jenkins URL
output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.jenkins_flask_instance.public_ip}:8080"
}
