terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  identifier = "routebox-${var.environment}"
}

# ------------------------------------------------------------------
# DB subnet group — all three private subnets.
# Mirrors CFN DbSubnetGroup which imported routebox-<env>-private-subnet-[1-3].
# ------------------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name        = local.identifier
  description = "Routebox ${var.environment} private subnets for RDS"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name        = local.identifier
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
  }
}

# ------------------------------------------------------------------
# Parameter group.
# ------------------------------------------------------------------

resource "aws_db_parameter_group" "main" {
  name   = local.identifier
  family = "postgres17"

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "600000"
  }

  parameter {
    name  = "statement_timeout"
    value = "60000"
  }

  tags = {
    Name        = local.identifier
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
  }
}

# ------------------------------------------------------------------
# Allow EKS workers to reach Postgres.
# The network module creates the RDS SG with ECS + Jenkins ingress rules.
# We add the EKS rule here, separate from network, to avoid coupling the
# network module to EKS (same pattern used for ECS/Jenkins there).
# ------------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = var.rds_security_group_id
  referenced_security_group_id = var.node_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Postgres from EKS worker nodes"
}

# ------------------------------------------------------------------
# RDS instance. Mirrors CFN DbInstance.
#
# - gp3 storage, encrypted at rest.
# - PubliclyAccessible = false; sits in private subnets.
# - AutoMinorVersionUpgrade = false (matches CFN; bump version deliberately).
# - final_snapshot_identifier is set so skip_final_snapshot=false works
#   without a cycle-prone timestamp(). Change the suffix if you need a
#   fresh snapshot name on a re-destroy.
# ------------------------------------------------------------------

resource "aws_db_instance" "main" {
  identifier        = local.identifier
  engine            = "postgres"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_master_username
  password = var.db_master_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]

  multi_az                = var.multi_az
  publicly_accessible     = false
  auto_minor_version_upgrade = false

  backup_retention_period = var.backup_retention_days
  maintenance_window      = "sun:07:00-sun:07:30"
  copy_tags_to_snapshot      = true
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = "${local.identifier}-final"

  tags = {
    Name        = local.identifier
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
  }
}
