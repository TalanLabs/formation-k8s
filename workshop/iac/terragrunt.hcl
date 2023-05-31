locals {
  region = "eu-west-3"
}

inputs = local

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "talan-formation-eks"
    key            = "terraform-state/mwf/${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
