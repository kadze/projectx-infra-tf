resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-addon-vpc-cni"
  })

  depends_on = [aws_eks_node_group.this]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-addon-coredns"
  })

  depends_on = [aws_eks_node_group.this]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-addon-kube-proxy"
  })

  depends_on = [aws_eks_node_group.this]
}
