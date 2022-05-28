terraform {
  required_version = ">= 0.13.0"
  
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "kubernetes" {
  host = var.kubernetes_config.host
  token = var.kubernetes_config.token
  cluster_ca_certificate = var.kubernetes_config.ca
}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_domain" "domain" {
  name = var.domain_name
}