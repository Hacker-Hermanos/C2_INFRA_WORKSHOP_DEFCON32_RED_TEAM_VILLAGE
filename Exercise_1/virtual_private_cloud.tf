resource "aws_vpc" "prod-vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "Default VPC (prod-vpc)"
  }
}

# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}


resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "172.31.0.0/16"
  map_public_ip_on_launch = "true" // This makes the aws_subnet 'prod-subnet-public-1' a public subnet by associating a public IP on startup
  availability_zone       = var.AVAILABILITY_ZONE
  tags = {
    Name = "/16 subnet in Default VPC (prod-subnet-public-1)"
  }
}

# create a custom route table for public subnets
# public subnets can reach to the internet buy using this
resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                      //associated subnet can reach everywhere
    gateway_id = aws_internet_gateway.prod-igw.id // Custom route table (CRT) uses IGW 'prod-igw' to reach internet
  }

  tags = {
    Name = "prod-public-crt"
  }
}

# route table association for the public subnets
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}
