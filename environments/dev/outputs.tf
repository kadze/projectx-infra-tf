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

output "jenkins_security_group_id" {
  description = "Jenkins security group ID."
  value       = module.network.jenkins_security_group_id
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint."
  value       = module.eks.cluster_endpoint
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster (used for IRSA)."
  value       = module.eks.oidc_issuer_url
}

output "node_security_group_id" {
  description = "Cluster-managed security group ID attached to worker nodes."
  value       = module.eks.node_security_group_id
}
