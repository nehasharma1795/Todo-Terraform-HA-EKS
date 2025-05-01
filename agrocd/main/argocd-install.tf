# Install ArgoCD using the official Helm chart
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6" # Latest stable version as of April 2025

  values = [
    <<-EOF
server:
  service:
    type: LoadBalancer
EOF
  ]
}
