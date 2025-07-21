
# =============================================================================
# SECURITY GROUPS MODULE - modules/security-groups/main.tf
# =============================================================================

resource "aws_security_group" "public_sg" {
  name        = "${var.project_name}-${var.environment}-public-sg"
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-sg"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Public"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-${var.environment}-private-sg"
  description = "Security group for private EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from public subnet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    description     = "SSH from public subnet"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-sg"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Private"
  }
}