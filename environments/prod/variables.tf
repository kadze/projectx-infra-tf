variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "prod"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for the three public subnets, in AZ order (a/b/c)."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for the three private subnets, in AZ order (a/b/c)."
}

variable "cost_center" {
  type        = string
  description = "Tag value for cost tracking."
  default     = "platform"
}
