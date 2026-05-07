module "network" {
  source = "../../modules/network"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cost_center          = var.cost_center
  enable_nat_gateway   = var.enable_nat_gateway
}

module "eks" {
  source = "../../modules/eks"

  environment                  = var.environment
  vpc_id                       = module.network.vpc_id
  public_subnet_ids            = module.network.public_subnet_ids
  kubernetes_version           = var.eks_kubernetes_version
  endpoint_public_access_cidrs = var.eks_endpoint_public_access_cidrs
  node_instance_types          = var.eks_node_instance_types
  node_capacity_type           = var.eks_node_capacity_type
  node_disk_size_gb            = var.eks_node_disk_size_gb
  node_min_size                = var.eks_node_min_size
  node_desired_size            = var.eks_node_desired_size
  node_max_size                = var.eks_node_max_size
  cluster_admin_role_arns      = var.eks_cluster_admin_role_arns
  cost_center                  = var.cost_center
}
