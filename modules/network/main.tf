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

resource "aws_security_group" "ecs" {
  name        = "routebox-${var.environment}-ecs-sg"
  description = "Routebox ECS service tasks. Inbound from the ALB only."
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "All ports from ALB. Tightened per-service in the task SG would be better."
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "routebox-${var.environment}-ecs-sg"
  }
}

resource "aws_security_group" "rds" {
  name        = "routebox-${var.environment}-rds-sg"
  description = "Routebox RDS Postgres. 5432 from ECS tasks and Jenkins."
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "routebox-${var.environment}-rds-sg"
  }
}

# RDS ingress rules are separate resources (not inline) to avoid dependency cycles.
resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Postgres from ECS tasks"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_jenkins" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.jenkins.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Postgres from Jenkins (migrations + ad-hoc)"
}

# TODO: add SSH ingress from bastion CIDR when bastion is provisioned.
resource "aws_security_group" "jenkins" {
  name        = "routebox-${var.environment}-jenkins-sg"
  description = "Jenkins EC2. 8080 from VPC, 22 from bastion CIDR (TODO)."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Jenkins UI inside the VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "routebox-${var.environment}-jenkins-sg"
  }
}
