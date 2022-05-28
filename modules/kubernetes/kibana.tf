locals {
  kibana = {
    name    = "kibana"
  }
}

resource "kubernetes_service" "kibana-service" {
  metadata {
    name = "${local.kibana.name}-svc"
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
        "app": local.kibana.name
    }
  }
  spec {
    # type = "NodePort"
    port {
      port = 80
      target_port = 5601
    }

    selector = {
      "app" = local.kibana.name
    }
  }
}

resource "kubernetes_ingress_v1" "ingress-kibana" {
  wait_for_load_balancer = true
  metadata {
    name = "${local.kibana.name}-ingress"
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    
    # tls {
    #   hosts = [
    #     "${var.stage}.${local.kibana.name}.${local.kibana.domain}"
    #   ]
    # }

    rule {
      host = "${var.stage}.${local.kibana.name}.${digitalocean_domain.domain.name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "${local.kibana.name}-svc"
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

resource "kubernetes_deployment" "deployment-kibana" {
  metadata {
    name = local.kibana.name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
      "app" = local.kibana.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app" = local.kibana.name
      }
    }
    template {
      metadata {
        labels = {
          "app" = local.kibana.name
        }
      }
      spec {
        container {
          name = local.kibana.name
          image = "docker.elastic.co/kibana/kibana:7.2.0"
          resources {
            limits = {
              "cpu" = "1000m"
            }
            requests = {
              "cpu" = "100m"
            }
          }
          env {
            name = "ELASTICSEARCH_URL"
            value = "http://elasticsearch:9200"
          }
          port {
            container_port = 5601
          }
        }
      }
    }
  }
}

resource "digitalocean_record" "www-kibana" {
  domain = digitalocean_domain.domain.name
  type = "A"
  name = "${var.stage}.${local.kibana.name}"
  ttl = 30
  
  value = kubernetes_ingress_v1.ingress-kibana.status.0.load_balancer.0.ingress.0.ip
}