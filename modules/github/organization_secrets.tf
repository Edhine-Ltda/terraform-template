
resource "github_actions_organization_secret" "org_digitalocean_token" {
  secret_name             = "DIGITALOCEAN_TOKEN"
  visibility              = "all"
  plaintext_value         = var.digitalocean_token
}

resource "github_actions_organization_secret" "org_digitalocean_registry_name" {
  secret_name             = "DIGITALOCEAN_REGISTRY_NAME"
  visibility              = "all"
  plaintext_value         = "edhine-registry"
}

resource "github_actions_organization_secret" "org_digitalocean_cluster_name" {
  secret_name             = "DIGITALOCEAN_CLUSTER_NAME"
  visibility              = "all"
  plaintext_value         = var.digitalocean_cluster_name
}