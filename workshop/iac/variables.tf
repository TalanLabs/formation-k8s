variable "region" {
  type = string
  default = "eu-west-3"
}


variable "participants" {
  description = "List of workshop's participant"
  type  = list(string)
  default = ["guillaume.azam", "charaf.zellou", "medhi.ouabbou", "caroline.guedj", "tyler.boyeka", "yacine.bengharsallah", "oussama.shili"]
}


variable "trainers" {
  description = "List of username on aws account of the workshop trainer. AWS account must already exists."
  type = list(string)
  default = ["guillaume.azam"]
}


variable "ingress_hostzone_name" {
  description = "The name of the DNS zone use for creating custom domain name for ingress controller."
  type = string
  default = "k8s.ruche-labs.net"
}

