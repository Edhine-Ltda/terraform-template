variable "fluentd_name" {
  default = "fluentd"
}

resource "kubernetes_service_account" "service-account-fluentd" {
  metadata {
    name      = var.fluentd_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
      "app" = var.fluentd_name
    }
  }
}

resource "kubernetes_cluster_role" "cluster-role-fluentd" {
  metadata {
    name = var.fluentd_name
    labels = {
      "app" = var.fluentd_name
    }
  }
  rule {
    api_groups = [""]
    resources = [
      "pods",
      "namespaces"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "cluster-role-binding-fluentd" {
  metadata {
    name = var.fluentd_name
  }

  role_ref {
    kind      = "ClusterRole"
    name      = var.fluentd_name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.fluentd_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
  }
}

resource "kubernetes_daemonset" "daemonset-fluentd" {
  metadata {
    name      = var.fluentd_name
    namespace = kubernetes_namespace.ns_logs.metadata[0].name
    labels = {
      "app" = var.fluentd_name
    }
  }

  spec {
    selector {
      match_labels = {
        "app" = var.fluentd_name
      }
    }

    template {
      metadata {
        labels = {
          "app" = var.fluentd_name
        }
      }
      spec {

        service_account_name = var.fluentd_name
        toleration {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
        container {
          name  = var.fluentd_name
          image = "fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1"

          env {
            name  = "FLUENT_ELASTICSEARCH_HOST"
            value = "elasticsearch.logs.svc.cluster.local"
          }

          env {
            name  = "FLUENT_ELASTICSEARCH_PORT"
            value = "9200"
          }

          env {
            name  = "FLUENT_ELASTICSEARCH_SCHEME"
            value = "http"
          }

          env {
            name  = "FLUENTD_SYSTEMD_CONF"
            value = "disable"
          }

          env {
            name = "FLUENT_CONTAINER_TAIL_EXCLUDE_PATH"
            value = "/var/log/containers/fluent*"
          }

          env {
            name = "FLUENT_CONTAINER_TAIL_PARSER_TYPE"
            value = "/^(?<time>.+) (?<stream>stdout|stderr)( (?<logtag>.))? (?<log>.*)$/"
          }

          resources {
              limits = {
                "memory" = "512Mi"
              }
              requests = {
                "cpu" = "100m"
                "memory" = "200Mi"
              }
          }
          volume_mount {
              name = "varlog"
              mount_path = "/var/log"
          }

          volume_mount {
            name = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only = true
          }
        }
        termination_grace_period_seconds = 20

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
      }
    }
  }

}
