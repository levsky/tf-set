# Create VPC 
resource "aws_vpc" "vpc-1" {
  cidr_block       = "10.0.0.0/22"
  #instance_tenancy = "dedicated"

  tags = {
    Name = "vpc-1"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc-1.id}"

  tags = {
    Name = "vpc-1"
  }
}

# Create private subnets
resource "aws_subnet" "private-1" {
  vpc_id     = "${aws_vpc.vpc-1.id}"
  cidr_block = "10.0.0.0/25"
  availability_zone = "us-west-2a"
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = "${aws_vpc.vpc-1.id}"
  cidr_block = "10.0.0.128/25"
  availability_zone = "us-west-2b"
  tags = {
    Name = "private-2"
  }
}


# Create public subnet
resource "aws_subnet" "public-1" {
  vpc_id     = "${aws_vpc.vpc-1.id}"
  cidr_block = "10.0.1.0/25"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = "${aws_vpc.vpc-1.id}"
  cidr_block = "10.0.1.128/25"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2"
  }
}

# Create elastic IP for NAT Gateway
resource "aws_eip" "ngw_ip"{
  vpc = true
  depends_on = ["aws_internet_gateway.igw"]
  tags{
    Name = "NAT Gateway"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngw_ip.id}"
  subnet_id     = "${aws_subnet.public-1.id}"
  depends_on = ["aws_internet_gateway.igw"]
  tags = {
    Name = "ngw-1"
  }
}

# Configure public network routing
resource "aws_route_table" "rt-public" {
  vpc_id = "${aws_vpc.vpc-1.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "public-1"
  }
}

resource "aws_route_table_association" "ra-public" {
  subnet_id = "${aws_subnet.public-1.id}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

# Configure private network routing 
resource "aws_route_table" "rt-private" {
  vpc_id = "${aws_vpc.vpc-1.id}"
  tags {
    Name = "private-1"
  }
}

resource "aws_route" "r-private" {
  route_table_id  = "${aws_route_table.rt-private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.ngw.id}"
}

resource "aws_route_table_association" "private_subnet-1" {
  subnet_id = "${aws_subnet.private-1.id}"
  route_table_id = "${aws_route_table.rt-private.id}"
}

resource "aws_db_subnet_group" "db_subnet_group_1" {
  name       = "main"
  subnet_ids = ["${aws_subnet.private-1.id}","${aws_subnet.private-2.id}"]

  tags = {
    Name = "default DB subnet group"
  }
}


