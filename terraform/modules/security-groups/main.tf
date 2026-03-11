# Create alb Security Groups
resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
  description = "Allow alb to expose port 80 to the internet"
  vpc_id = var.vpc_id
  tags = {
    Name = "alb-sg"
  }
  ingress {
    description = "Opening port 80 for everyone"
    from_port = var.alb_port
    to_port = var.alb_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# Create container security group
resource "aws_security_group" "container-sg" {
  name = "container-sg"
  description = "Allow app-containers to connect with alb"
  vpc_id = var.vpc_id
  tags = {
    Name = "container-sg"
  }
  ingress {
      description = "Allow port 8000 of containers to connect with alb"
      from_port = var.container_port
      to_port = var.container_port
      protocol = "tcp"
      security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}













