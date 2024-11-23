
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.pragmatic_terraform.id
  cidr_block              = "10.0.64.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "pragmatic-terraform-private"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.pragmatic_terraform.id

  tags = {
    Name = "pragmatic-terraform-private"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.pragmatic_terraform.id
  destination_cidr_block = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
