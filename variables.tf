##################################
# Variables SO                   #
#                                #
# TF_VAR_github_token            #
variable "github_token" {}       #
# TF_VAR_digitalocean_token      #
variable "digitalocean_token" {} #
##################################


###########
# .tfvars #
###########

variable "stage" {}

# Digital Ocean
variable "do_domain_name" {}

# Github
variable "gh_owner" {}

# Kubernetes
variable "k8s_name_cluster" {}
variable "k8s_size" {}
variable "k8s_autoscale" {}
variable "k8s_min_nodes" {}
variable "k8s_max_nodes" {}
variable "k8s_version" {}
variable "k8s_region" {}
