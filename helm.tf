resource "helm_release" "nginx" {
  name             = "nginx-ingress"
  repository       = "https://helm.nginx.com/stable"
  chart            = "nginx-ingress"
  create_namespace = true
  timeout = 900
  namespace        = "nginx-ingress"
}


resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.14.4"

  namespace        = "cert-manager"
  create_namespace = true

  timeout = 900
  wait    = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]

  values = [
    file("helm-values/cert-manager.yaml")
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.15.0"

  namespace        = "external-dns"
  create_namespace = true

  values = [
    file("helm-values/external-dns.yaml")
  ]
}


resource "helm_release" "argocd_deploy" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.6.12" # optional but recommended

  timeout = 600
}



