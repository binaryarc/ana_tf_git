######################## SUBNET  ##########################

resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.ana.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true #인스턴스 생성시 공인IP 자동 할당
  tags = {
    Name = "ANA-WC-PUBLIC-SUBNET-2A"
  }
}

resource "aws_subnet" "pub_c" {
  vpc_id                  = aws_vpc.ana.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "ANA-WC-PUBLIC-SUBNET-2C"
  }
}

resource "aws_subnet" "pri_a_01" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "ANA-WC-PRIVATE-EKS-SUBNET-2A"
  }
}

resource "aws_subnet" "pri_c_01" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "ANA-WC-PRIVATE-EKS-SUBNET-2C"
  }
}

resource "aws_subnet" "pri_a_02" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "ANA-WC-PRIVATE-NODES-SUBNET-2A"
  }
}

resource "aws_subnet" "pri_c_02" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.50.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "ANA-WC-PRIVATE-NODES-SUBNET-2C"
  }
}

resource "aws_subnet" "pri_a_03" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.60.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "ANA-WC-PRIVATE-RDS-SUBNET-2A"
  }
}

resource "aws_subnet" "pri_c_03" {
  vpc_id            = aws_vpc.ana.id
  cidr_block        = "10.0.70.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "ANA-WC-PRIVATE-RDS-SUBNET-2C"
  }
}


######################## ROUTE TABLE ########################

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.ana.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ANA-WC-PUBLIC-RT"
  }
}

resource "aws_route_table" "pri_01" {
  vpc_id = aws_vpc.ana.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_01.id
  }
  tags = {
    Name = "ANA-WC-PRIVATE-EKS-RT"
  }
}

resource "aws_route_table" "pri_02" {
  vpc_id = aws_vpc.ana.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_01.id
  }
  tags = {
    Name = "ANA-WC-PRIVATE-NODES-RT"
  }
}

resource "aws_route_table" "pri_03" {
  vpc_id = aws_vpc.ana.id
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.priC-nat.id
  # }
  tags = {
    Name = "ANA-WC-PRIVATE-RDS-RT"
  }
}

resource "aws_route_table_association" "public-a-rtb" {
  subnet_id      = aws_subnet.pub_a.id
  route_table_id = aws_route_table.pub.id
}
resource "aws_route_table_association" "public-c-rtb" {
  subnet_id      = aws_subnet.pub_c.id
  route_table_id = aws_route_table.pub.id
}
resource "aws_route_table_association" "eks_private-a-rtb" {
  subnet_id      = aws_subnet.pri_a_01.id
  route_table_id = aws_route_table.pri_01.id
}
resource "aws_route_table_association" "eks_private-c-rtb" {
  subnet_id      = aws_subnet.pri_c_01.id
  route_table_id = aws_route_table.pri_01.id
}
resource "aws_route_table_association" "nodes_private-a-rtb" {
  subnet_id      = aws_subnet.pri_a_02.id
  route_table_id = aws_route_table.pri_02.id
}
resource "aws_route_table_association" "nodes_private-c-rtb" {
  subnet_id      = aws_subnet.pri_c_02.id
  route_table_id = aws_route_table.pri_02.id
}
resource "aws_route_table_association" "rds_private-a-rtb" {
  subnet_id      = aws_subnet.pri_a_03.id
  route_table_id = aws_route_table.pri_03.id
}
resource "aws_route_table_association" "rds_private-c-rtb" {
  subnet_id      = aws_subnet.pri_c_03.id
  route_table_id = aws_route_table.pri_03.id
}

######################## EIP 생성 ########################

resource "aws_eip" "nat" {
  vpc = true
  
  lifecycle {
    create_before_destroy = true
  }
}

######################## nat GW 생성 ########################

resource "aws_nat_gateway" "nat_gw_01" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_a.id

  tags = {
    Name = "ANA-WC-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}