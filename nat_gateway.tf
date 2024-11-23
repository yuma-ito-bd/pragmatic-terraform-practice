# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat_gateway" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "pragmatic_terraform" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway"
  }
}
