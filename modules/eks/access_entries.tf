resource "aws_eks_access_entry" "admin" {
  count = var.admin_role_arn != "" ? 1 : 0

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.admin_role_arn
  type          = "STANDARD"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-admin-access-entry"
  })
}

resource "aws_eks_access_policy_association" "admin" {
  count = var.admin_role_arn != "" ? 1 : 0

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.admin_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}
