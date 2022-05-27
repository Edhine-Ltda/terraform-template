locals {
  name = "hello"
  ingress = {
    domain_root = var.domain_name
  }
}

resource "kubernetes_service" "app-test-service" {
  metadata {
    name      = "hello-svc"
    labels = {
      "app" = "hello"
    }
  }
  spec {
    type = "NodePort"
    port {
      port        = 80
      target_port = 8080
    }
    selector = {
      "app" = "hello"
    }
  }
}

resource "kubernetes_ingress_v1" "ingress-hello" {
  wait_for_load_balancer = true
  metadata {
    name = "ingress-hello"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    
    tls {
      hosts = [
        "api.${local.ingress.domain_root}"
      ]
    }

    rule {
      host = "api.${local.ingress.domain_root}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "${local.name}-svc"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "app-test-deployment" {
  metadata {
    name = local.name
    labels = {
      "app" = local.name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app" = local.name
      }
    }

    template {
        metadata {
            labels = {
              "app" = local.name
            }
        }

        spec {
            container {
                name = local.name
                image = "gcr.io/google-samples/hello-app:1.0"
                port {
                  container_port = 8080
                }
            }
        }
    }
  }
}

resource "digitalocean_domain" "domain" {
  name = local.ingress.domain_root
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.domain.name
  type = "A"
  name = "api"
  ttl = 30
  
  value = kubernetes_ingress_v1.ingress-hello.status.0.load_balancer.0.ingress.0.ip
}