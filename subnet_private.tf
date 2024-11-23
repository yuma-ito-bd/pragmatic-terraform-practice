
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.pragmatic_terraform.id
  cidr_block              = "10.0.65.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "pragmatic-terraform-private_0"
  }
}
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.pragmatic_terraform.id
  cidr_block              = "10.0.66.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "pragmatic-terraform-private_1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.pragmatic_terraform.id

  tags = {
    Name = "pragmatic-terraform-private_0"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.pragmatic_terraform.id

  tags = {
    Name = "pragmatic-terraform-private_1"
  }
}

resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.pragmatic_terraform_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.pragmatic_terraform_1.id
  destination_cidr_block = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}
