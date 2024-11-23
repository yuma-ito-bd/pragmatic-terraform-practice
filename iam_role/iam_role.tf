variable "name" {}
variable "policy" {}
variable "identifier" {}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/iam_role
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/iam_policy
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}
