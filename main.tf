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
    Name = "prvsubnet-${ENV}-${element(var.AZ,count.index)}"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.AZ)
  cidr_block              = element(var.PUBLC_SUBNET,count.index)
  availability_zone       = element(var.AZ,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "publcsubnet-${ENV}-${count.index}"
  }
}
