resource "digitalocean_kubernetes_cluster" "edhine-cluster" {
  name    = "edhine-cluster"
  region  = "nyc1"
  version = "1.22.8-do.1"

  node_pool {
    name       = "edhine-autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 1
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
