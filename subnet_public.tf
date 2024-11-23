
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.pragmatic_terraform.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "pragmatic-terraform-public"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "pragmatic_terraform" {
  vpc_id = aws_vpc.pragmatic_terraform.id

  tags = {
    Name = "pragmatic-terraform"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pragmatic_terraform.id

  tags = {
    Name = "pragmatic-terraform-public"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.pragmatic_terraform.id
  destination_cidr_block = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
