variable "kibana_name" {
  default = "kibana"
}

resource "kubernetes_service" "service-kibana" {
  metadata {
    name = var.kibana_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
        "app": var.kibana_name
    }
  }
  spec {
    # type = "NodePort"
    port {
      port = 80
      target_port = 5601
    }

    selector = {
      "app" = var.kibana_name
    }
  }
}

resource "kubernetes_deployment" "deployment-kibana" {
  metadata {
    name = var.kibana_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = var.kibana_name
      }
    }
    template {
      metadata {
        labels = {
          "app" = var.kibana_name
        }
      }
      spec {
        container {
          name = var.kibana_name
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