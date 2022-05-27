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
variable "domain_name" {}

# Github
variable "owner" {}

# Kubernetes
variable "name_cluster" {}
variable "size" {}
variable "autoscale" {}
variable "min_nodes" {}
variable "max_nodes" {}