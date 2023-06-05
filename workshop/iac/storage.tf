resource "aws_security_group" "efs" {
  name        = "${local.name} efs"
  description = "Allow traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "TCP"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }
}

resource "aws_iam_policy" "node_efs_policy" {
  name        = "eks_node_efs-${local.name}"
  path        = "/"
  description = "Policy for EFKS nodes to use EFS"

  policy = jsonencode({
    "Statement": [
      {
        "Action": [
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:CreateAccessPoint",
          "elasticfilesystem:DeleteAccessPoint",
          "ec2:DescribeAvailabilityZones"
        ],
        "Effect": "Allow",
        "Resource": "*",
        "Sid": ""
      }
    ],
    "Version": "2012-10-17"
  }
  )
}

resource "aws_iam_role" "efs_role" {
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": module.eks.oidc_provider_arn
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "efs" {
  policy_arn = aws_iam_policy.node_efs_policy.arn
  role       = aws_iam_role.efs_role.name
}

resource "aws_efs_file_system" "kube" {
  creation_token = "eks-efs"
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.kube.id
  subnet_id = each.key
  for_each = toset(module.vpc.private_subnets )
  security_groups = [aws_security_group.efs.id]
}


resource "helm_release" "efs" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/eks/aws-efs-csi-driver"
  }

  depends_on = [
    kubernetes_service_account.efs_csi_controller
  ]
}

resource "kubernetes_service_account" "efs_csi_controller" {
  metadata {
    name = "efs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn"=aws_iam_role.efs_role.arn
    }
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name" = "efs-csi-controller"
    }
  }
}
