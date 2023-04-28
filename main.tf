resource "aws_vpc" "main" {
  cidr_block             = var.VPC_CIDR
  enable_dns_hostnames   = true
  tags = {
    Name = "vpc-${var.ENV}"
  }

}

resource "aws_subnet" "private" {
  vpc_id                = aws_vpc.main.id
  count                 = length(var.AZ)
  cidr_block            = element(var.PRVT_SUBNET,count.index)
  availability_zone     = element(var.AZ,count.index)

  tags = {
    Name = "prvsubnet-${var.ENV}-${element(var.AZ,count.index)}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.AZ)
  cidr_block              = element(var.PUBLC_SUBNET,count.index)
  availability_zone       = element(var.AZ,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "publcsubnet-${var.ENV}-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.ENV}"
  }
}


resource "aws_vpc_peering_connection" "roboshop_peering" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.PEER_VPC_ID
  auto_accept   = true
}

//public route table

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.DEFAULT_CIDR
    vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_peering.id
  }
   route {
    cidr_block = var.ALLOW_ALL_CIDR
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "publicRouteTable-${var.ENV}"
  }
}

//public subnet route table association
resource "aws_route_table_association" "publicRouteAssoc" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.publicRoute.id
}


// Private route table

resource "aws_route_table" "privateRoute" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.DEFAULT_CIDR
    vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_peering.id
  }
   route {
    cidr_block     = var.ALLOW_ALL_CIDR
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "privateRouteTable-${var.ENV}"
  }
}

//private subnet route table association
resource "aws_route_table_association" "privateRoute" {
  count          = length(aws_subnet.private.*.id)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.privateRoute.id
}





// EIP Creation
resource "aws_eip" "eip" {
  vpc      = true
  tags = {
    Name = "eip-roboshop-${var.ENV}"
  }
}

//NAt gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.*.id[1]

  tags = {
    Name = "gw NAT-${var.ENV}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip]
}


#Default route table association

resource "aws_route" "r" {
  route_table_id            = var.DEFAULT_RT
  destination_cidr_block    = var.VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_peering.id
  depends_on                = [aws_vpc_peering_connection.roboshop_peering]
}

