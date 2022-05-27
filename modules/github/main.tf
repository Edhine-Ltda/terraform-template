terraform {
  required_version = ">= 0.13.0"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.owner
}
