# Security Group for Public Webservers (Allows HTTP/SSH)
resource "aws_security_group" "web_sg" {
  name        = "WebServerSG"
  vpc_id      = aws_vpc.project_vpc.id
  description = "Allow HTTP and SSH access for Webservers"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "WebServerSG" })
}

# Security Group for Private Instances (Restrict access to Bastion)
resource "aws_security_group" "private_sg" {
  name        = "PrivateInstanceSG"
  vpc_id      = aws_vpc.project_vpc.id
  description = "Allow SSH access from Bastion host"

  ingress {
    description     = "Allow SSH traffic from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "PrivateInstanceSG" })
}
