resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count = 2
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = ["ap-south-1a", "ap-south-1b"][count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = 2
  cidr_block = "10.0.${count.index + 10}.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = ["ap-south-1a", "ap-south-1b"][count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "default" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count = 2
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [
    aws_internet_gateway.igw,
    aws_route.default,
    aws_route_table.public_rt
  ]
}
