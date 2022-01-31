resource "aws_vpc" "fuel50-vpc" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"
   enable_dns_support = true
   enable_dns_hostnames = true
   tags = {
    Name = "fuel50-vpc"
 }
}

resource "aws_subnet" "fuel50-vpc-public-1" {
   vpc_id            = aws_vpc.fuel50-vpc.id
   cidr_block        = "10.0.1.0/24"
   map_public_ip_on_launch = true
   availability_zone = "ap-southeast-2a"

   tags = {
     "name" = "fuel50-vpc-public-1"
   }
}

resource "aws_subnet" "fuel50-vpc-public-2" {
   vpc_id            = aws_vpc.fuel50-vpc.id
   cidr_block        = "10.0.2.0/24"
   map_public_ip_on_launch = true
   availability_zone = "ap-southeast-2b"

   tags = {
     "name" = "fuel50-vpc-public-2"
   }
}

resource "aws_internet_gateway" "fuel50-gw" {
   vpc_id = aws_vpc.fuel50-vpc.id

   tags={
     Name = "fuel50-gw"
   }
 }

resource "aws_route_table" "fuel50-rt" {
   vpc_id = aws_vpc.fuel50-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.fuel50-gw.id
   }

   route {
     ipv6_cidr_block = "::/0"
     gateway_id      = aws_internet_gateway.fuel50-gw.id
   }

 }

resource "aws_route_table_association" "fuel50-vpc-public-1-a" {
   subnet_id      = aws_subnet.fuel50-vpc-public-1.id
   route_table_id = aws_route_table.fuel50-rt.id
 }

resource "aws_route_table_association" "fuel50-vpc-public-2-b" {
   subnet_id      = aws_subnet.fuel50-vpc-public-2.id
   route_table_id = aws_route_table.fuel50-rt.id
 }

 