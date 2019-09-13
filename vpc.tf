# Fetch AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "myapp" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  tags = {
    name = "${var.app_prefix}"
    env  = "${var.env}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "myapp" {
  vpc_id = "${aws_vpc.myapp.id}"
  tags = {
    name = "${aws_vpc.myapp.tags.name}_internetGW"
    env  = "${var.env}"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.myapp.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.myapp.id}"
  depends_on             = ["aws_internet_gateway.myapp"]
}

resource "aws_subnet" "myapp1" {
  vpc_id                  = "${aws_vpc.myapp.id}"
  cidr_block              = "${var.subnet1}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags = {
    name = "${aws_vpc.myapp.tags.name}-subnet-1"
    env  = "${var.env}"
  }
}

resource "aws_subnet" "myapp2" {
  vpc_id                  = "${aws_vpc.myapp.id}"
  cidr_block              = "${var.subnet2}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  tags = {
    name = "${aws_vpc.myapp.tags.name}-subnet-2"
    env  = "${var.env}"
  }
}

