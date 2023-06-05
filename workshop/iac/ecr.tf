data "aws_caller_identity" "current" {}

module "ecr" {
  for_each = toset(["back", "front"])
  source = "terraform-aws-modules/ecr/aws"

  repository_force_delete = true
  repository_name = "${local.name}-${each.key}"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 2 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 2
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Project    = local.name
  }
}
