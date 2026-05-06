variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes control plane version."
  default     = "1.35"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID from the network module."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs from the network module. Used for the EKS control plane vpc_config."
}

variable "node_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs where worker nodes are deployed. In dev use public subnets (no NAT needed). In staging/prod use private subnets."
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for managed node group workers."
  default     = "t3.medium"
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes."
  default     = 2
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes."
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes."
  default     = 3
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod)."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to all resources."
  default     = {}
}

variable "admin_role_arn" {
  type        = string
  description = "IAM role ARN granted AmazonEKSClusterAdminPolicy. Leave empty to skip access entry creation."
  default     = ""
}
