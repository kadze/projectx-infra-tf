# ------------------------------------------------------------------
# ClusterIssuers — one for Let's Encrypt staging (safe for testing,
# no rate limits) and one for production.
# Both use DNS-01 via Route53 cross-account: cert-manager assumes
# the delegate role in the Route53 account to write TXT records.
# ------------------------------------------------------------------

resource "kubectl_manifest" "cluster_issuer_staging" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
    spec:
      acme:
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        email: ${var.acme_email}
        privateKeySecretRef:
          name: letsencrypt-staging
        solvers:
          - dns01:
              route53:
                region: us-east-1
                hostedZoneID: ${var.route53_hosted_zone_id}
                role: arn:aws:iam::${var.route53_account_id}:role/routebox-cert-manager-route53-delegate
  YAML

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer_prod" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${var.acme_email}
        privateKeySecretRef:
          name: letsencrypt-prod
        solvers:
          - dns01:
              route53:
                region: us-east-1
                hostedZoneID: ${var.route53_hosted_zone_id}
                role: arn:aws:iam::${var.route53_account_id}:role/routebox-cert-manager-route53-delegate
  YAML

  depends_on = [helm_release.cert_manager]
}
