# ------------------------------------------------------------------
# cert-manager — namespace + Helm release.
# IRSA annotation on the service account binds it to the
# routebox-${var.environment}-cert-manager IAM role so the controller
# can assume the Route53 delegate role for DNS-01 challenges.
# ------------------------------------------------------------------

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  depends_on = [aws_eks_node_group.main]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_chart_version
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  values = [yamlencode({
    installCRDs = true
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.cert_manager.arn
      }
    }
  })]

  depends_on = [
    aws_eks_node_group.main,
    aws_iam_openid_connect_provider.eks,
  ]
}
