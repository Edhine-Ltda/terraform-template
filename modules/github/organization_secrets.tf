data "github_repository" "repo" {
  full_name = "${var.gh_owner}/hairdressing-angular-front"
}

resource "github_actions_organization_secret" "org_digitalocean_token" {
  secret_name             = "DIGITALOCEAN_TOKEN"
  visibility              = "selected"
  plaintext_value         = var.digitalocean_token
  selected_repository_ids = [
    data.github_repository.repo.repo_id
  ]
}

resource "github_actions_organization_secret" "org_digitalocean_registry_name" {
  secret_name             = "DIGITALOCEAN_REGISTRY_NAME"
  visibility              = "selected"
  plaintext_value         = "hairdressing-registry"
  selected_repository_ids = [
    data.github_repository.repo.repo_id
  ]
}

resource "github_actions_organization_secret" "org_digitalocean_cluster_name" {
  secret_name             = "DIGITALOCEAN_CLUSTER_NAME"
  visibility              = "selected"
  plaintext_value         = var.digitalocean_cluster_name
  selected_repository_ids = [
    data.github_repository.repo.repo_id
  ]
}