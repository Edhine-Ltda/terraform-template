variable "elasticsearch_name" {
  default = "elasticsearch"
}

resource "kubernetes_service" "service-elasticsearch" {
  metadata {
    name = var.elasticsearch_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
      "app" = var.elasticsearch_name
    }
  }

  spec {
    selector = {
      "app" = var.elasticsearch_name
    }
    cluster_ip = "None"
    port {
      name = "rest"
      port = 9200
    }
    port {
      name = "inter-node"
      port = 9300
    }
  }
}

resource "kubernetes_stateful_set" "stateful-set-elasticsearch" {
  metadata {
    name      = "es-cluster"
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
  }

  spec {
    service_name = var.elasticsearch_name
    replicas     = 1
    selector {
      match_labels = {
        "app" = var.elasticsearch_name
      }
    }
    template {
      metadata {
        labels = {
          "app" = var.elasticsearch_name
        }
      }
      spec {
        container {
          name  = var.elasticsearch_name
          image = "docker.elastic.co/elasticsearch/elasticsearch:7.2.0"
          resources {
            limits = {
              "cpu" = "1000m"
            }
            requests = {
              "cpu" = "100m"
            }
          }
          port {
            container_port = 9200
            name           = "rest"
            protocol       = "TCP"
          }
          port {
            container_port = 9300
            name           = "inter-node"
            protocol       = "TCP"
          }

          volume_mount {
            name       = "data"
            mount_path = "/usr/share/${var.elasticsearch_name}/data"
          }

          env {
            name  = "cluster.name"
            value = "k8s-logs"
          }

          env {
            name = "node.name"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "discovery.seed_hosts"
            value = "es-cluster-0.elasticsearch"
          }

          env {
            name  = "cluster.initial_master_nodes"
            value = "es-cluster-0"
          }

          env {
            name  = "ES_JAVA_OPTS"
            value = "-Xms512m -Xmx512m"
          }
        }

        init_container {
          name    = "fix-permissions"
          image   = "busybox"
          command = ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
          security_context {
            privileged = true
          }
          volume_mount {
            name       = "data"
            mount_path = "/usr/share/elasticsearch/data"
          }
        }

        init_container {
          name    = "increase-vm-max-map"
          image   = "busybox"
          command = ["sysctl", "-w", "vm.max_map_count=262144"]
          security_context {
            privileged = true
          }
        }

        init_container {
          name    = "increase-fd-ulimit"
          image   = "busybox"
          command = ["sh", "-c", "ulimit -n 65536"]
          security_context {
            privileged = true
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "data"
        labels = {
          "app" = var.elasticsearch_name
        }
      }
      spec {
        access_modes = [ "ReadWriteOnce" ]
        storage_class_name = "do-block-storage"
        resources {
          requests = {
            "storage" = "20Gi"
          }
        }
      }
    }
  }
}

