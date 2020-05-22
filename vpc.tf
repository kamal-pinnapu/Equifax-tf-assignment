# Provider
provider "aws" {
	region = "${var.aws_region}"
}
# VPC
resource "aws_vpc" "equifax_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  tags {
    Name = "equifax_VPC"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "equifax_igw" {
  vpc_id = "${aws_vpc.equifax_vpc.id}"
  tags {
    Name = "equifax_igw"
  }
}
# Elastic IP
resource "aws_eip" "eip" {
}
# Nat Gateway
resource "aws_nat_gateway" "equifax_ngw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${element(aws_subnet.equifax_public.*.id,count.index)}"
  tags = {
    Name = "equifax_ngw"
  }

  depends_on = ["aws_internet_gateway.equifax_igw"]
}
# Subnets : public
resource "aws_subnet" "equifax_public" {
  count = "${length(var.public_cidr)}"
  vpc_id = "${aws_vpc.equifax_vpc.id}"
  cidr_block = "${element(var.public_cidr,count.index)}"
  availability_zone = "${element(var.public_azs,count.index)}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.public_subnet}-${count.index+1}"
  }
}
# Subnets : private
resource "aws_subnet" "equifax_private" {
  count = "${length(var.private_cidr)}"
  vpc_id = "${aws_vpc.equifax_vpc.id}"
  cidr_block = "${element(var.private_cidr,count.index)}"
  availability_zone = "${element(var.private_azs,count.index)}"
  tags {
    Name = "${var.private_subnet}-${count.index+1}"
  }
}
# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.equifax_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.equifax_igw.id}"
  }
  tags {
    Name = "${var.public_route_table}"
  }
}
# Route table: attach Nat Gateway 
resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.equifax_vpc.id}"
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = "${aws_nat_gateway.equifax_ngw.id}"
  }
  tags {
    Name = "${var.private_route_table}"
  }
}
# Route table association with private subnets
resource "aws_route_table_association" "rt_pvt" {
  count           = "${length(var.public_cidr)}"
  subnet_id       = "${element(aws_subnet.equifax_private.*.id,count.index)}"
  route_table_id  = "${aws_route_table.private_rt.id}"
}
# Route table association with public subnets
resource "aws_route_table_association" "rt_public" {
  count = "${length(var.public_cidr)}"
  subnet_id      = "${element(aws_subnet.equifax_public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

