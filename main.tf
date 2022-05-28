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

  stage = var.stage
  k8s_region = var.k8s_region
  k8s_version = var.k8s_version
  k8s_name_cluster = var.k8s_name_cluster
  k8s_size = var.k8s_size
  k8s_autoscale = var.k8s_autoscale
  k8s_min_nodes = var.k8s_min_nodes
  k8s_max_nodes = var.k8s_max_nodes
}

module "github" {
  source       = ".//modules/github"
  github_token = var.github_token
  digitalocean_token = var.digitalocean_token
  
  gh_owner = var.gh_owner
  digitalocean_cluster_name = module.digitalocean.cluster_name
}

module "kubernetes" {
  source = ".//modules/kubernetes"
  digitalocean_token = var.digitalocean_token

  stage = var.stage
  do_domain_name = var.do_domain_name
  kubernetes_config = module.digitalocean.kubernetes_config
}

module "helm" {
  source = ".//modules/helm"
  kubernetes_config = module.digitalocean.kubernetes_config
}