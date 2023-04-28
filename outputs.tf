output "ROBO_VPC_ID"{
  value = aws_vpc.main.id
}

output "PRVT_SUBNET_IDS"{
  value = aws_subnet.private.*.id
}
output "PUBLC_SUBNET_IDS"{
  value = aws_subnet.public.*.id
}

/////////////////////


output defaultVPCcidr{
value = var.DEFAULT_CIDR
}


output peer_vpc_id{
value = var.PEER_VPC_ID
}

output publicSubnet_cidrs{
  value = aws_subnet.public.*.cidr_block
}

output privateSubnet_cidrs{
value = aws_subnet.private.*.cidr_block
}
output env{
value = var.ENV
}

output vpc_cidr{
value = var.VPC_CIDR
}



output PRIVATE_HOSTED_ZONE_ID{
value = var.PRIVATE_HOSTED_ZONE_ID
}
output PRIVATE_HOSTED_ZONE_NAME {
value = var.PRIVATE_HOSTED_ZONE_NAME
}
output PUBLIC_HOSTED_ZONE_ID {
value = var.PUBLIC_HOSTED_ZONE_ID
}
output PUBLIC_HOSTED_ZONE_NAME {
value = var.PUBLIC_HOSTED_ZONE_NAME
}