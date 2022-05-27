terraform {
  cloud {
    organization = "Edhine"

    workspaces {
      tags = ["k8s"]
    }
  }
}

module "digitalocean" {
  source = ".//modules/digitalocean"
  digitalocean_token = var.digitalocean_token

  name_cluster = var.name_cluster
  size = var.size
  autoscale = var.autoscale
  min_nodes = var.min_nodes
  max_nodes = var.max_nodes
}

module "github" {
  source       = ".//modules/github"
  github_token = var.github_token
  digitalocean_token = var.digitalocean_token
  
  owner = var.owner
  digitalocean_cluster_name = var.name_cluster
}

module "kubernetes" {
  source = ".//modules/kubernetes"
  digitalocean_token = var.digitalocean_token

  domain_name = var.domain_name
  kubernetes_config = module.digitalocean.kubernetes_config
}

module "helm" {
  source = ".//modules/helm"
  kubernetes_config = module.digitalocean.kubernetes_config
}