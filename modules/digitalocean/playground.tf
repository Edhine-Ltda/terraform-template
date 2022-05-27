# resource "digitalocean_project" "hairdressing" {
#   name        = "hairdressing"
#   description = "This project represents an application for the management of hairdressers"
#   purpose     = "Web Application"
#   environment = "Development"
#   resources = [ 
#     digitalocean_kubernetes_cluster.hairdressing-cluster.urn
#   ]
# }