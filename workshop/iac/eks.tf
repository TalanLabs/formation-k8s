locals {
  name            = "formation-k8s"
  cluster_version = "1.26"
  region          = var.region
}

data "aws_iam_user" "trainers" {
  count = length(var.trainers)
  user_name = var.trainers[count.index]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = local.name
  cluster_version = local.cluster_version

  vpc_id          = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


    # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_users = concat(
    [for trainer in tolist(data.aws_iam_user.trainers): { userarn = trainer.arn, username = trainer.user_name , groups   = ["system:masters"]}],
    [for participant in tolist(aws_iam_user.participant): { userarn = participant.arn, username = participant.name , groups   = []}]
  )


  # Managed Node Groups
  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  eks_managed_node_groups = {
    example = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  kms_key_administrators = [for trainer in tolist(data.aws_iam_user.trainers): trainer.arn]

  tags = {
    Project    = local.name
  }
}

################################################################################
# Kubernetes provider configuration
################################################################################

data "aws_eks_cluster" "cluster" {
  name = local.name
  depends_on = [
    module.eks.cluster_id
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.name
  depends_on = [
    module.eks.cluster_id
  ]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "formation" {
  metadata {
    name = "formation"
  }
}

################################################################################
# Kubernetes workshop specific resssource
################################################################################


resource "kubernetes_namespace" "participant" {
  count = length(var.participants)
  metadata {
    name = replace(var.participants[count.index], ".", "-")
  }
}

resource "kubernetes_role" "participant" {
  count = length(var.participants)
  metadata {
    name =  replace(var.participants[count.index], ".", "-")
    namespace = replace(var.participants[count.index], ".", "-")
  }
  rule {
    api_groups     = [""]
    resources      = ["*"]
    verbs          = ["*"]
  }
  rule {
    api_groups     = [""]
    resources      = ["*"]
    verbs          = ["*"]
  }
}


resource "kubernetes_role_binding" "participant" {
  count = length(var.participants)
  metadata {
    name =  replace(var.participants[count.index], ".", "-")
    namespace = replace(var.participants[count.index], ".", "-")
  }
  subject {
    kind      = "User"
    name      = replace(var.participants[count.index], ".", "-")
    api_group = "rbac.authorization.k8s.io"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = replace(var.participants[count.index], ".", "-")
  }
}

################################################################################
# Supporting resources
################################################################################

data "aws_availability_zones" "available" {
}

locals {
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = local.name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = local.private_subnets
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

  tags = {
    Project    = local.name
  }
}
