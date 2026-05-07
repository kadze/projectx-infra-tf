variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
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

variable "enable_nat_gateway" {
  type        = bool
  description = "Create a NAT gateway and Elastic IP in this environment."
  default     = false
}

# ------------------------------------------------------------------
# EKS — mirrors the eks module's variables. Values come from dev.tfvars.
# ------------------------------------------------------------------

variable "eks_kubernetes_version" {
  type        = string
  description = "Kubernetes minor version pinned on the EKS cluster."
}

variable "eks_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the API server."
}

variable "eks_node_instance_types" {
  type        = list(string)
  description = "Allowed node instance types for the managed node group."
}

variable "eks_node_capacity_type" {
  type        = string
  description = "Node capacity type: SPOT or ON_DEMAND."
}

variable "eks_node_disk_size_gb" {
  type        = number
  description = "Root EBS volume size per node, GiB."
}

variable "eks_node_min_size" {
  type        = number
  description = "Minimum node count."
}

variable "eks_node_desired_size" {
  type        = number
  description = "Desired node count at apply time. Subsequent changes are ignored so the cluster autoscaler can drift it."
}

variable "eks_node_max_size" {
  type        = number
  description = "Maximum node count."
}

variable "eks_cluster_admin_role_arns" {
  type        = list(string)
  description = "IAM role ARNs to grant cluster-admin via EKS access entries. Typically the SSO admin role for this account."
}
