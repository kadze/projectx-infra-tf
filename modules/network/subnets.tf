resource "aws_subnet" "public" {
  for_each = local.public_subnet_map

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = data.aws_availability_zones.available.names[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = {
    Name = "routebox-${var.environment}-public-${each.value.suffix}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnet_map

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = data.aws_availability_zones.available.names[tonumber(each.key)]
  map_public_ip_on_launch = false

  tags = {
    Name = "routebox-${var.environment}-private-${each.value.suffix}"
    Tier = "private"
  }
}
