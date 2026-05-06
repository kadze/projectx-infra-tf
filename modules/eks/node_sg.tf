resource "aws_security_group" "nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "EKS worker nodes. No internet inbound; full outbound for image pulls and AWS APIs."
  vpc_id      = var.vpc_id

  egress {
    description = "All outbound — image pulls, AWS APIs, DNS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodes-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "nodes_from_cluster_sg" {
  security_group_id            = aws_security_group.nodes.id
  referenced_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  ip_protocol                  = "-1"
  description                  = "Inbound from EKS cluster security group (control plane + nodes that carry the cluster SG)"
}

resource "aws_vpc_security_group_ingress_rule" "nodes_self" {
  security_group_id            = aws_security_group.nodes.id
  referenced_security_group_id = aws_security_group.nodes.id
  ip_protocol                  = "-1"
  description                  = "Node-to-node within node security group"
}
