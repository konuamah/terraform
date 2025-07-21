provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "my_first_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
 associate_public_ip_address = true
 
 key_name = "my-key"
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "my-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "public-subnet"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id


    tags = {
        Name = "my-internet-gateway"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "public-route-table"
    }
  
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_security_group" "allow_ssh_http" {
    name = "allow_ssh_http"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = aws_vpc.main.id
    
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #allows ssh from anywhere
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #allows http from anywhere
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
   

    tags = {
        Name = "allow_ssh_http"
    }
  
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "private-subnet"
    }
  
}

resource "aws_instance" "private_instance" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                  = aws_subnet.private_subnet.id
  vpc_security_group_ids     = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from private EC2" > /var/www/html/index.html
              EOF

  tags = {
    Name = "private-instance"
  }
}


resource "aws_security_group" "private_sg" {
    name        = "private-ec2-sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.allow_ssh_http.id] 
    }

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.allow_ssh_http.id] 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    tags = {
        Name = "private-ec2-sg"
    }
}

resource "aws_eip" "nat_eip" {


    tags = {
        Name = "nat-eip"
    }
  
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet.id

    tags = {
        Name = "nat-gateway"
    }


depends_on = [ aws_internet_gateway.gw ]
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gw.id
    }

    tags = {
        Name = "private-route-table"
    }
  
  
}

resource "aws_route_table_association" "private_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
  
}