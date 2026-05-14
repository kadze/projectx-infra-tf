environment = "dev"
cost_center = "platform-dev"

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.0.0/22",
  "10.10.4.0/22",
  "10.10.8.0/22",
]

private_subnet_cidrs = [
  "10.10.16.0/20",
  "10.10.32.0/20",
  "10.10.48.0/20",
]

enable_nat_gateway = false

# ------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------

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
  "arn:aws:iam::414866527708:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_1a0f858bba60ce65",
  "arn:aws:iam::414866527708:role/gha-routebox-shipments-api-dev",
]