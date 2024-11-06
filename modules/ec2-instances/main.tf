# Launch EC2 Instance and install Dockerized Jenkins, Flask web server
resource "aws_instance" "jenkins_flask_instance" {
  ami           = "ami-0ddc798b3f1a5117e"  # amazon Linux 2 AMI
  instance_type = "t2.micro"               # Free-tier eligible instance
   # Use the key pair created earlier
 # key_name = aws_key_pair.ec2_key.key_name
  key_name = module.ec2_tls_key.key_name
  # Associate security group
  vpc_security_group_ids = [aws_security_group.jenkins_flask_sg.id]

  # Specify the path to the private key for SSH access
  #connection {
   # type        = "ssh"
    #user        = "ec2-user"  # Use the correct username for your AMI
   # private_key = file("~/aws-private-key.pem")
 # }

  # User data script to install Docker, Jenkins, Python Flask, and run the Flask app
  user_data = <<-EOF
    #!/bin/bash
    # Update and install basic dependencies
    yum update -y
    yum install -y docker python3
    yum install -y java 11 open jdk develop

    # Start Docker service
    service docker start
    usermod -aG docker ec2-user 
    sudo chmod 666 /var/run/docker.sock 

    # Install Flask
    pip3 install flask

    # Create a simple Flask app
    cat << 'EOF2' > /home/ec2-user/app.py
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def hello_world():
        return 'Hello from Flask Web Server! - welcome Osler medical device test '

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=5000)
    EOF2

    # Start Flask app in background
    nohup python3 /home/ec2-user/app.py &

    # Pull and run Jenkins in Docker
    sudo mkdir -p /var/jenkins_home
    sudo chown -R 1000:1000 /var/jenkins_home
    sudo chmod -R 775 /var/jenkins_home
    sudo docker pull jenkins/jenkins:lts
    sudo docker run -d -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home  --name jenkins-server jenkins/jenkins:lts && sudo chmod -R 777 /var
    
    # Wait for Jenkins to start
    sleep 30 

    # Install Jenkins CLI and TestNG Plugin
    JENKINS_URL="http://localhost:8080"
    CLI_JAR="/var/jenkins_home/war/WEB-INF/jenkins-cli.jar"
    
    wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar" -P /var/jenkins_home/war/WEB-INF

    ADMIN_PASSWORD=$(cat /var/jenkins_home/secrets/initialAdminPassword) 

    # Download necessary plugins
       #JENKINS_PLUGINS="workflow-aggregator workflow-cps workflow-job testng-plugin"
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin testng-plugin 
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin workflow-cps 
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin workflow-job
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin workflow-aggregator
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin ionicons-api
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin workflow-step-api
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin pipeline-groovy-lib
     java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" install-plugin structs
      # Restart Jenkins
      docker restart jenkins-server
    
    #java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" restart 

    # Wait for Jenkins to restart
    sleep 60

    # Create Jenkins pipeline job
    cat << 'EOF2' > Maven-pipeline-job 
    ${file("./Maven-pipeline-job")}  
    EOF2

    java -jar "$CLI_JAR" -s "$JENKINS_URL" -auth admin:"$ADMIN_PASSWORD" groovy = < Maven-pipeline-job
  EOF

  # Add a tag to the EC2 instance
  tags = {
    Name = "JenkinsFlaskServer"
  }

  # Block device (optional)
  root_block_device {
    volume_size = 20  # Root volume size in GB
  }

  # Associate a public IP address
  associate_public_ip_address = true
}
