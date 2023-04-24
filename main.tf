resource "aws_vpc" "main" {
  cidr_block       = var.VPC_CIDR
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

resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = var.PEER_VPC_ID
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
}