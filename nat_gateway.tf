# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat_gateway_0" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway_0"
  }
}

resource "aws_eip" "nat_gateway_1" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway_1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "pragmatic_terraform_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id

  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway_0"
  }
}

resource "aws_nat_gateway" "pragmatic_terraform_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [aws_internet_gateway.pragmatic_terraform]

  tags = {
    Name = "pragmatic-terraform-nat-gateway_1"
  }
}
