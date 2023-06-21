variable "region" {
  type = string
}


variable "participants" {
  description = "List of workshop's participant"
  type  = list(string)
  default = [ "thomas.cami" ]
}


variable "trainers" {
  description = "List of username on aws account of the workshop trainer. AWS account must already exists."
  type = list(string)
  default = ["guillaume.azam", "bertrand.nau"]
}


variable "ingress_hostzone_name" {
  description = "The name of the DNS zone use for creating custom domain name for ingress controller."
  type = string
  default = "k8s.ruche-labs.net"
}

