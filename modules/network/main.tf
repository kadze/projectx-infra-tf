resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "routebox-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "routebox-${var.environment}-igw"
  }
}

resource "aws_security_group" "alb" {
  name        = "routebox-${var.environment}-alb-sg"
  description = "Routebox public ALB. Open 80/443 from the internet."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from the internet (redirected to HTTPS at the listener)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from the internet"
    from_port   = 443
    to_port     = 443
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
    Name = "routebox-${var.environment}-alb-sg"
  }
}


resource "aws_security_group" "rds" {
  name        = "routebox-${var.environment}-rds-sg"
  description = "Routebox RDS Postgres. 5432 from EKS workers."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "routebox-${var.environment}-rds-sg"
  }

  lifecycle {
    ignore_changes = [description]
  }
}
