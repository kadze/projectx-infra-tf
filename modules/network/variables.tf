variable "environment" {
  type        = string
  description = "Deployment environment. Drives resource names and tags."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC. /16 in practice."

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block (e.g. 10.10.0.0/16)."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for the three public subnets, in AZ order (a/b/c)."

  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "public_subnet_cidrs must contain exactly 3 CIDRs."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for the three private subnets, in AZ order (a/b/c)."

  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "private_subnet_cidrs must contain exactly 3 CIDRs."
  }
}

variable "cost_center" {
  type        = string
  description = "Tag value applied to billable resources."
  default     = "platform"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create a NAT gateway and its Elastic IP. Set false in dev to save costs; private subnets will have no egress route."
  default     = true
}
