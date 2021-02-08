resource "aws_vpc" "production-vpc" {
  cidr_block = "10.0.0.0/16"  # Define overall VPC address space
  enable_dns_support = true  # Enable DNS resolving support for this VPC
  enable_dns_hostnames = true  # Enable DNS hostnames for this VPC
  tags = {
    Name = "VPC-${var.environment}"  # Tag VPC with name
  }
}

resource "aws_subnet" "pub-web-az-a" {
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.11.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Subnet-AP-South-1a-Web"
  }
}

resource "aws_subnet" "pub-web-az-b" {
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.12.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Subnet-AP-South-1b-Web"
  }
}

resource "aws_subnet" "priv-db-az-a" {
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Subnet-AP-South-1a-DB"
  }
}

resource "aws_subnet" "priv-db-az-b" {
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Subnet-AP-South-1b-DB"
  }
}

resource "aws_internet_gateway" "inetgw" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "IGW-VPC-${var.enviroment}-Default"
  }
}

resource "aws_route_table" "ap-default" {
  vpc_id = aws_vpc.production-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.inetgw.id}"
  }
  tags = {
    Name = "Route-Table-AP-Default"
  }
}

resource "aws_route_table_association" "ap-south-1a-public" {
  route_table_id = "${aws_route_table.ap-default.id}"
  subnet_id = "${aws_subnet.pub-web-az-a.id}"
}

resource "aws_route_table_association" "ap-south-1b-public" {
  route_table_id = "${aws_route_table.ap-default.id}"
  subnet_id = "${aws_subnet.pub-web-az-b.id}"
}

resource "aws_route_table_association" "ap-south-1a-private" {
  route_table_id = "${aws_route_table.ap-default.id}"
  subnet_id = "${aws_subnet.priv-db-az-a.id}"
}

resource "aws_route_table_association" "ap-south-1b-private" {
  route_table_id = "${aws_route_table.ap-default.id}"
  subnet_id = "${aws_subnet.priv-db-az-b.id}"
}

