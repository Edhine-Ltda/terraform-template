terraform {
  required_version = ">= 0.12.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
  }
}
