variable "digitalocean_token" {
    description = "DigitalOcean Token PAC"
    type = string
}

variable "stage" {
  description = "Ambiente"
}

variable "k8s_version" {
    description = "version cluster"
}

variable "k8s_region" {
    description = "Region del cluster"
}   

variable "k8s_name_cluster" {
  description = "Nombre cluster kubernetes"
}

variable "k8s_size" {
    description = "ID del tamaño del cluster"
}

variable "k8s_autoscale" {
    description = ""
    type = bool
}

variable "k8s_min_nodes" {
    description = "Minimo de nodos del cluster"
    type = number
}

variable "k8s_max_nodes" {
    description = "Maximo de nodos del cluster"
    type = number
}