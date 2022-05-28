resource "digitalocean_kubernetes_cluster" "edhine-cluster" {
  name    = "${var.stage}-${var.k8s_name_cluster}"
  region  = var.k8s_region
  version = var.k8s_version

  node_pool {
    name       = "${var.stage}-${var.k8s_name_cluster}-worker-pool"
    size       = var.k8s_size
    auto_scale = var.k8s_autoscale
    min_nodes  = var.k8s_min_nodes
    max_nodes  = var.k8s_max_nodes
  }
}

output "kubernetes_config" {
  description = "Kubernetes config"
  value = {
    ca    = base64decode(digitalocean_kubernetes_cluster.edhine-cluster.kube_config.0.cluster_ca_certificate)
    token = digitalocean_kubernetes_cluster.edhine-cluster.kube_config.0.token
    host  = digitalocean_kubernetes_cluster.edhine-cluster.endpoint
  }
}

output "cluster_name" {
  description = "Cluster name kubernetes"
  value = digitalocean_kubernetes_cluster.edhine-cluster.name
}
