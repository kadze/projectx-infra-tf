terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
}
}

locals {
  cluster_name = "routebox-${var.environment}"
}

# ------------------------------------------------------------------
# CloudWatch log group for control plane logs.
# Declared explicitly so retention is set up front. Without this,
# EKS auto-creates the group on first apply with "Never expire".
# Name is fixed by EKS: /aws/eks/<cluster>/cluster.
# ------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 30

  tags = {
    Name = "${local.cluster_name}-eks-logs"
  }
}

# ------------------------------------------------------------------
# Cluster.
#
# - Control plane ENIs and nodes in public subnets (project decision).
# - Endpoint public, IAM-auth gated, CIDR list per env.
# - All control plane log types on; retention pre-set above.
# - Envelope encryption for K8s secrets via customer-managed KMS key.
# - access_config = API means access entries only, no aws-auth ConfigMap.
#   bootstrap_cluster_creator_admin_permissions is off so the apply
#   role does not get implicit admin; access is granted explicitly via
#   var.cluster_admin_role_arns (see access.tf).
# ------------------------------------------------------------------

resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.public_subnet_ids
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = var.endpoint_public_access_cidrs
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_secrets.arn
    }
    resources = ["secrets"]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  tags = {
    Name = local.cluster_name
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# ------------------------------------------------------------------
# Managed node group. Nodes go in public subnets — map_public_ip_on_launch
# is true on those subnets, so nodes get public IPs and reach the internet
# directly without NAT.
#
# The default cluster SG that EKS creates only allows inbound from the
# control plane, so the public IP is not reachable from the open internet.
#
# desired_size is ignored after create so the cluster autoscaler
# (when added later) won't fight Terraform.
# ------------------------------------------------------------------

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.cluster_name}-default"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.public_subnet_ids

  instance_types = var.node_instance_types
  capacity_type  = var.node_capacity_type
  disk_size      = var.node_disk_size_gb
  ami_type       = "AL2023_x86_64_STANDARD"

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable_percentage = 33
  }

  tags = {
    Name = "${local.cluster_name}-default"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonSSMManagedInstanceCore,
  ]
}

# ------------------------------------------------------------------
# Second AWS provider scoped to the Route53 account (381492277294).
# Terraform assumes var.route53_deployment_role_arn (a role that
# already exists in that account) to create the cert-manager
# delegate role there. Route53 is global so region is cosmetic.
# ------------------------------------------------------------------

provider "aws" {
  alias  = "route53_account"
  region = "us-east-1"

  assume_role {
    role_arn = var.route53_deployment_role_arn
  }
}
