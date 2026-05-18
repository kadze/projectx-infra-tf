output "vpc_id" {
  description = "VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs (index 0-2, AZ a/b/c)."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs (index 0-2, AZ a/b/c)."
  value       = module.network.private_subnet_ids
}

output "public_subnet_1_id" {
  description = "Public subnet AZ a."
  value       = module.network.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "Public subnet AZ b."
  value       = module.network.public_subnet_2_id
}

output "public_subnet_3_id" {
  description = "Public subnet AZ c."
  value       = module.network.public_subnet_3_id
}

output "private_subnet_1_id" {
  description = "Private subnet AZ a."
  value       = module.network.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "Private subnet AZ b."
  value       = module.network.private_subnet_2_id
}

output "private_subnet_3_id" {
  description = "Private subnet AZ c."
  value       = module.network.private_subnet_3_id
}

output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = module.network.alb_security_group_id
}

output "ecs_service_security_group_id" {
  description = "ECS service security group ID."
  value       = module.network.ecs_service_security_group_id
}

output "rds_security_group_id" {
  description = "RDS security group ID."
  value       = module.network.rds_security_group_id
}

# ------------------------------------------------------------------
# EKS outputs.
# ------------------------------------------------------------------

# output "cluster_name" {
#   description = "EKS cluster name."
#   value       = module.eks.cluster_name
# }

# output "cluster_endpoint" {
#   description = "Kubernetes API server endpoint."
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_certificate_authority_data" {
#   description = "Base64-encoded cluster CA cert."
#   value       = module.eks.cluster_certificate_authority_data
#   sensitive   = true
# }

# output "cluster_oidc_issuer_url" {
#   description = "OIDC issuer URL for IRSA."
#   value       = module.eks.cluster_oidc_issuer_url
# }

# output "cluster_security_group_id" {
#   description = "EKS-managed cluster SG ID."
#   value       = module.eks.cluster_security_group_id
# }

# output "node_security_group_id" {
#   description = "Node SG ID."
#   value       = module.eks.node_security_group_id
# }

# output "oidc_provider_arn" {
#   description = "IRSA OIDC provider ARN."
#   value       = module.eks.oidc_provider_arn
# }

# output "kms_key_arn" {
#   description = "KMS key ARN used for K8s secrets envelope encryption."
#   value       = module.eks.kms_key_arn
# }

# ------------------------------------------------------------------
# ECR outputs.
# ------------------------------------------------------------------

output "ecr_repository_urls" {
  description = "ECR repository URLs keyed by service name."
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "ECR repository ARNs keyed by service name."
  value       = module.ecr.repository_arns
}

# ------------------------------------------------------------------
# RDS outputs.
# ------------------------------------------------------------------

# output "db_endpoint" {
#   description = "RDS Postgres hostname."
#   value       = module.rds.db_endpoint
# }

# output "db_port" {
#   description = "RDS Postgres port."
#   value       = module.rds.db_port
# }

# output "db_instance_identifier" {
#   description = "RDS instance identifier."
#   value       = module.rds.db_instance_identifier
# }

# output "db_name" {
#   description = "Database name."
#   value       = module.rds.db_name
# }
