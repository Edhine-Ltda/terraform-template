variable "digitalocean_token" {
    description = "DigitalOcean Token PAC"
    type = string
}

variable "name_cluster" {
  description = "Nombre cluster kubernetes"
  type = string
}

variable "size" {
    description = "ID del tamaño del cluster"
    type = string
    default = "s-2vcpu-2gb"
}

variable "autoscale" {
    description = ""
    type = bool
    default = true
}

variable "min_nodes" {
    description = "Minimo de nodos del cluster"
    type = number
    default = 1
}

variable "max_nodes" {
    description = "Maximo de nodos del cluster"
    type = number
    default = 1
}