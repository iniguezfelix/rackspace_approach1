# Custom VPC
resource "aws_vpc" "vpc_approach1" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Approach 1 VPC"
  }
}

#Internet gateway for the public subnet
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_approach1.id
  tags = {
    Name        = "IGW"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat1_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat1_gateway" {
  allocation_id = aws_eip.nat1_eip.id
  subnet_id     = aws_subnet.public_us_east_1a.id
  depends_on    = [aws_internet_gateway.vpc_igw]
  tags = {
    Name        = "NAT Gateway 1a"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat2_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat2_gateway" {
  allocation_id = aws_eip.nat2_eip.id
  subnet_id     = aws_subnet.public_us_east_1b.id
  depends_on    = [aws_internet_gateway.vpc_igw]
  tags = {
    Name        = "NAT Gateway 1b"
  }
}


#Subnets Private for web servers Public for Bastion host
resource "aws_subnet" "private_us_east_1a" {
  vpc_id     = aws_vpc.vpc_approach1.id
  cidr_block = var.private1a_cidr_block
  availability_zone = var.az1

  tags = {
    Name = "Private Subnet us-east-1a"
  }
}

resource "aws_subnet" "private_us_east_1b" {
  vpc_id     = aws_vpc.vpc_approach1.id
  cidr_block = var.private1b_cidr_block
  availability_zone = var.az2

  tags = {
    Name = "Private Subnet us-east-1b"
  }
}

resource "aws_subnet" "public_us_east_1a" {
  vpc_id     = aws_vpc.vpc_approach1.id
  cidr_block = var.public1a_cidr_block
  availability_zone = var.az1

  tags = {
    Name = "Public Subnet us-east-1a"
  }
}

resource "aws_subnet" "public_us_east_1b" {
  vpc_id     = aws_vpc.vpc_approach1.id
  cidr_block = var.public1b_cidr_block
  availability_zone = var.az2

  tags = {
    Name = "Public Subnet us-east-1b"
  }
}


#Routing table for private and public subnets
resource "aws_route_table" "private1a" {
    vpc_id = aws_vpc.vpc_approach1.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id =  aws_nat_gateway.nat1_gateway.id
    }

    tags = {
        Name = "1a-private-route-table"
    }
}

resource "aws_route_table" "private1b" {
    vpc_id = aws_vpc.vpc_approach1.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id =  aws_nat_gateway.nat2_gateway.id
    }

    tags = {
        Name = "1a-private-route-table"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc_approach1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.vpc_igw.id
    }

    tags = {
        Name = "1b-public-route-table"
    }
}

#Route table associations
resource "aws_route_table_association" "my_vpc_us_east_1a_private" {
    subnet_id = aws_subnet.private_us_east_1a.id
    route_table_id = aws_route_table.private1a.id
}

resource "aws_route_table_association" "my_vpc_us_east_1b_private" {
    subnet_id = aws_subnet.private_us_east_1b.id
    route_table_id = aws_route_table.private1b.id
}

resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.public_us_east_1a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "my_vpc_us_east_1b_public" {
    subnet_id = aws_subnet.public_us_east_1b.id
    route_table_id = aws_route_table.public.id
}