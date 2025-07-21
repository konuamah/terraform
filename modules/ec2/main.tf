
resource "aws_instance" "public_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-instance"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Public"
  }
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_security_group_id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ${var.project_name} private EC2 - ${var.environment}</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-instance"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Private"
  }
}