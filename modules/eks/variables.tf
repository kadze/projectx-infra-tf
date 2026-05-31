variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod). Drives the cluster name and resource names."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID from the network module."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for control plane ENIs and managed node group. Three required, one per AZ. Public subnets have map_public_ip_on_launch = true so nodes get public IPs and reach the internet directly without NAT."

  validation {
    condition     = length(var.public_subnet_ids) == 3
    error_message = "public_subnet_ids must have exactly 3 entries."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes minor version pinned on the EKS cluster. Bump in a separate deliberate PR — addons follow this version via aws_eks_addon_version data sources."
  default     = "1.35"
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the Kubernetes API server. IAM-gated; lock down to operator egress IPs once stable."
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.endpoint_public_access_cidrs) > 0
    error_message = "endpoint_public_access_cidrs must contain at least one CIDR."
  }
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for the managed node group. Multiple entries allow capacity substitution (relevant for SPOT)."
  default     = ["t3.medium"]

  validation {
    condition     = length(var.node_instance_types) > 0
    error_message = "node_instance_types must contain at least one instance type."
  }
}

variable "node_capacity_type" {
  type        = string
  description = "SPOT or ON_DEMAND. SPOT is cheaper and fine for dev/staging; prod uses ON_DEMAND."

  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.node_capacity_type)
    error_message = "node_capacity_type must be SPOT or ON_DEMAND."
  }
}

variable "node_disk_size_gb" {
  type        = number
  description = "Root EBS volume size per node in GiB."
  default     = 20
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes."
}

variable "node_desired_size" {
  type        = number
  description = "Desired node count at apply time. Subsequent changes are ignored so the cluster autoscaler can drift it."
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes."
}

variable "cluster_admin_role_arns" {
  type        = list(string)
  description = "IAM role ARNs granted AmazonEKSClusterAdminPolicy via EKS access entries. Typically the SSO admin role. Leave empty to bootstrap without admins — bootstrap_cluster_creator_admin_permissions is off, so you must set this before applying or you will have no kubectl path in."
  default     = []
}

variable "cost_center" {
  type        = string
  description = "Cost-allocation tag value."
  default     = "platform"
}

# ------------------------------------------------------------------
# cert-manager / TLS
# ------------------------------------------------------------------

variable "route53_account_id" {
  description = "AWS account ID that owns the Route53 hosted zone used for ACME DNS-01 challenges."
  type        = string
}

variable "route53_hosted_zone_id" {
  description = "Route53 hosted zone ID for ACME DNS-01 challenge."
  type        = string
}

variable "route53_deployment_role_arn" {
  description = "ARN of an IAM role in the Route53 account that Terraform assumes (via aws.route53_account provider) to create the cert-manager delegate role there."
  type        = string
}
