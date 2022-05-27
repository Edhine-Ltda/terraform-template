provider "helm" {
  debug = true
    kubernetes {
      host = var.kubernetes_config.host
      token = var.kubernetes_config.token
      cluster_ca_certificate = var.kubernetes_config.ca
    }
}