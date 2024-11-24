variable "name" {}
variable "vpc_id" {}
variable "port" {}
variable "cidr_ipv4" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "default" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "default" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
}

output "security_group_id" {
  value = aws_security_group.default.id
}
