output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster (used for IRSA)."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_security_group_id" {
  description = "Cluster-managed security group ID attached to worker nodes."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
