provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH traffic"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  key_name               = "atome-key"
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd git
              systemctl enable httpd
              systemctl start httpd
              cd /var/www/html
              git clone https://gitlab.com/collection4devops/website_lugx_gaming.git
              mv website_lugx_gaming/* .
              rm -rf website_lugx_gaming
              EOF

  tags = {
    Name = "lugx-gaming-server"
  }
}
