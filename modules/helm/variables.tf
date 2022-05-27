variable "kubernetes_config" {
  description = "locate filename kubernetes config"
  type = object({
    host = string
    token = string
    ca = string
  })
}