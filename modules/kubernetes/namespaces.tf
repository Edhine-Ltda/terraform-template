resource "kubernetes_namespace" "ns_development" {
  metadata {
    name = "development"
  }
}

resource "kubernetes_namespace" "ns_qa" {
  metadata {
    name = "qa"
  }
}

resource "kubernetes_namespace" "ns_logs" {
  metadata {
    name = "logs"
  }
}

resource "kubernetes_namespace" "ns_ingress" {
  metadata {
    name = "ingress"
  }
}