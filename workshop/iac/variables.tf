variable "region" {
  type = string
}


variable "participants" {
  description = "List of workshop's participant"
  type  = list(string)
  default = [ "thomas.cami", "stephane.thurneyssen" ]
}


variable "trainers" {
  description = "List of username on aws account of the workshop trainer. AWS account must already exists."
  type = list(string)
  default = ["guillaume.azam", "bertrand.nau"]
}