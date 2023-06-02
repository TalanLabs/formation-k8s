variable "region" {
  type = string
}


variable "participants" {
  type  = list(string)
  default = [ "thomas.cami", "stephane.thurneyssen" ]
}