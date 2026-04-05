# Create a VPC
resource "aws_vpc" "app-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "app-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "app_public_sub" {
  count = var.public_subnet_count

  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "app_public_sub"
  }
}



# Create private subnets
resource "aws_subnet" "app_private_sub" {
  count = var.private_subnet_count

  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "app_private_sub"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "app-igw"
  }
}

# Create NAT gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "app-nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.app_public_sub[0].id
}

# Create private route table
resource "aws_route_table" "app-priv-rt" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app-nat-gw.id
  }
}

# Create public route table
resource "aws_route_table" "app-pb-rt" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name = "app-pb-rt"
  }
}

# Create public subnet association with route table
resource "aws_route_table_association" "app-rt-asc-pub" {
  count          = length(aws_subnet.app_public_sub)
  route_table_id = aws_route_table.app-pb-rt.id
  subnet_id      = aws_subnet.app_public_sub[count.index].id
}

# Create private subnet association with route table
resource "aws_route_table_association" "app-rt-asc-priv" {
  count          = length(aws_subnet.app_private_sub)
  route_table_id = aws_route_table.app-priv-rt.id
  subnet_id      = aws_subnet.app_private_sub[count.index].id
}

