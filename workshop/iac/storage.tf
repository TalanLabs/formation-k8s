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
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:CreateAccessPoint"
        ],
        "Resource": "*",
        "Condition": {
          "StringLike": {
            "aws:RequestTag/efs.csi.aws.com/cluster": "true"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:TagResource"
        ],
        "Resource": "*",
        "Condition": {
          "StringLike": {
            "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": "elasticfilesystem:DeleteAccessPoint",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
          }
        }
      }
    ]
  })
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
  count = length(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.kube.id
  subnet_id = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
  depends_on = [
    module.vpc.private_subnets
  ]
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

  set {
    name  = "replicaCount"
    value = "1"
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
      "app.kubernetes.io/name" = "aws-efs-csi-driver"
    }
  }
}

resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId = aws_efs_file_system.kube.id
    directoryPerms = "777"
  }
}
