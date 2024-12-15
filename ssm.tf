# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "Database username"
}

resource "aws_ssm_parameter" "db_raw_password" {
  name        = "/db/password"
  value       = "password"
  type        = "SecureString"
  description = "Database password"

  lifecycle {
    ignore_changes = [value]
  }
}
