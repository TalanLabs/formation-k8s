################################################################################
# Create AWS user and group
################################################################################

resource "aws_iam_group" "participant" {
  name = "k8s-formation-participants"
}

# add authorization to participants group
data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "read_only_access" {
  group      = aws_iam_group.participant.name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}

data "aws_iam_policy" "user_change_password" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy_attachment" "user_change_password" {
  group      = aws_iam_group.participant.name
  policy_arn = data.aws_iam_policy.user_change_password.arn
}

data "aws_iam_user" "participants" {
  count = length(var.participants)
  user_name = var.participants[count.index]
}

resource "aws_iam_user_group_membership" "participant" {
  count = length(var.participants)
  user = var.participants[count.index]
  groups = [ aws_iam_group.participant.name ]
}
