environment          = "staging"
vpc_cidr             = "10.20.0.0/16"
public_subnet_cidrs  = ["10.20.0.0/22", "10.20.4.0/22", "10.20.8.0/22"]
private_subnet_cidrs = ["10.20.16.0/20", "10.20.32.0/20", "10.20.48.0/20"]
cost_center          = "platform-staging"
enable_nat_gateway   = false

eks_kubernetes_version           = "1.35"
eks_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_node_instance_types          = ["t3.medium"]
eks_node_capacity_type           = "SPOT"
eks_node_disk_size_gb            = 20
eks_node_min_size                = 2
eks_node_desired_size            = 2
eks_node_max_size                = 4

# IMPORTANT: set this to your SSO admin role ARN before applying,
# otherwise nobody will have kubectl access (bootstrap_cluster_creator_admin_permissions = false).
# Find your role ARN: AWS Console -> IAM -> Roles -> search AWSReservedSSO_Administrator
eks_cluster_admin_role_arns = [
  "arn:aws:iam::318492844364:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_9e310257231aed8e",
  "arn:aws:iam::318492844364:role/gha-routebox-shipments-api-staging",
]
