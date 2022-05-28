variable "kubernetes_config" {
  description = "locate filename kubernetes config"
  type = object({
    host = string
    token = string
    ca = string
  })
}
variable "digitalocean_token" {
  description = "token digital ocean"
  type = string
}

variable "domain_name" {
  default = "domain name root"
  type = string
}

variable "stage" {
  default = "nombre ambiente"
  type = string
}