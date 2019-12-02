# Create VPC 
resource "aws_vpc" "k8s" {
  cidr_block = "${var.vpc-cidr}"
  #instance_tenancy = "dedicated"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.vpc-name}"
  }
}

# Upload public key
resource "aws_key_pair" "kops" {
  key_name   = "kops"
  public_key = "${var.public_key}"
}

# Create DNS zone
resource "aws_route53_zone" "public" {
  name = "k8s.local"

  tags = {
    Name = "public"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.k8s.id}"

  tags = {
    Name = "k8s"
  }
}

# Create DNS zone
//resource "aws_route53_zone" "private" {
  //name = "levsky.net"

  //vpc {
    //vpc_id = "${aws_vpc.k8s-1.id}"
  //}

  //tags = {
    //Name = "private"
  //}
//}

