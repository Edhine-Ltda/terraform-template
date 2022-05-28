locals {
  app = {
    name = "hello"
  }
}

resource "kubernetes_service" "app-test-service" {
  metadata {
    name      = "${local.app.name}-svc"
    labels = {
      "app" = local.app.name
    }
  }
  spec {
    # type = "NodePort"
    port {
      port        = 80
      target_port = 8080
    }
    selector = {
      "app" = local.app.name
    }
  }
}

resource "kubernetes_ingress_v1" "ingress-app" {
  wait_for_load_balancer = true
  metadata {
    name = "${local.app.name}-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    
    # tls {
    #   hosts = [
    #     "api.${local.app.domain}"
    #   ]
    # }

    rule {
      host = "${var.stage}.${local.app.name}.${digitalocean_domain.domain.name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "${local.app.name}-svc"
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
    name = local.app.name
    labels = {
      "app" = local.app.name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app" = local.app.name
      }
    }

    template {
        metadata {
            labels = {
              "app" = local.app.name
            }
        }

        spec {
            container {
                name = local.app.name
                image = "gcr.io/google-samples/hello-app:1.0"
                port {
                  container_port = 8080
                }
            }
        }
    }
  }
}

resource "digitalocean_record" "www-app" {
  domain = digitalocean_domain.domain.name
  type = "A"
  name = "${var.stage}.${local.app.name}"
  ttl = 30
  
  value = kubernetes_ingress_v1.ingress-app.status.0.load_balancer.0.ingress.0.ip
}