variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod)."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID from the network module."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the DB subnet group. Three required, one per AZ."

  validation {
    condition     = length(var.private_subnet_ids) == 3
    error_message = "private_subnet_ids must have exactly 3 entries."
  }
}

variable "rds_security_group_id" {
  type        = string
  description = "RDS security group ID from the network module. The module adds an ingress rule from EKS workers."
}

variable "node_security_group_id" {
  type        = string
  description = "EKS cluster/node security group ID. Granted ingress to port 5432."
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class. dev uses db.t3.micro; prod should override to db.t3.medium or larger."
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage in GiB."
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 1000
    error_message = "db_allocated_storage must be between 20 and 1000 GiB."
  }
}

variable "db_engine_version" {
  type        = string
  description = "Postgres engine version."
  default     = "17.7"
}

variable "db_master_username" {
  type        = string
  description = "Master DB username."
  default     = "routebox_admin"
}

variable "db_master_password" {
  type        = string
  description = "Master DB password. Minimum 16 characters. Pass via TF_VAR_rds_db_master_password or a .auto.tfvars file — do not commit it."
  sensitive   = true

  validation {
    condition     = length(var.db_master_password) >= 16
    error_message = "db_master_password must be at least 16 characters."
  }
}

variable "db_name" {
  type        = string
  description = "Initial database name."
  default     = "routebox"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ standby. Off for dev/staging, on for prod."
  default     = false
}

variable "backup_retention_days" {
  type        = number
  description = "Automated backup retention period in days. 0 disables automated backups entirely."
  default     = 0
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent the instance from being deleted via the API. Enable in prod."
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip the final snapshot on destroy. Set false in prod."
  default     = true
}

variable "cost_center" {
  type        = string
  description = "Cost-allocation tag value."
  default     = "platform"
}
