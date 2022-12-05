resource "aws_vpc" "ana" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "ANA-VPC-Worldcup"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ana.id

  tags = {
    Name = "ANA-WC-igw"
  }
}