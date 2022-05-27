resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  namespace = "ingress"
  
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  wait = true
  
  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "controller.publishService.enabled"
    value = true
  }
}