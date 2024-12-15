# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "pragmatic_terraform" {
  description             = "KMS key for Pragmatic Terraform"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "pragmatic_terraform" {
  name          = "alias/pragmatic_terraform"
  target_key_id = aws_kms_key.pragmatic_terraform.key_id
}
