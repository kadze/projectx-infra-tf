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

  cluster_name       = "routebox-dev"
  kubernetes_version = "1.35"
  environment        = "dev"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  node_subnet_ids    = module.network.public_subnet_ids

  node_instance_type = "t3.medium"
  node_desired_size  = 2
  node_min_size      = 1
  node_max_size      = 3

  tags = {
    Environment = "dev"
    Project     = "routebox"
    ManagedBy   = "terraform"
  }
}
