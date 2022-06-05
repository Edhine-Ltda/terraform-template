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
  name = var.do_domain_name
}

resource "digitalocean_record" "www-public-api" {
  domain = digitalocean_domain.domain.name
  type = "A"
  name = "${var.stage}.public-api"
  ttl = 30
  
  value = kubernetes_ingress_v1.ingress-app.status.0.load_balancer.0.ingress.0.ip
}