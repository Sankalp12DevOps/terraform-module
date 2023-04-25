output "ROBO_VPC_ID"{
  value = aws_vpc.main.id
}

output "PRVT_SUBNET_IDS"{
  value = aws_subnet.private.*.id
}
output "PUBLC_SUBNET_IDS"{
  value = aws_subnet.public.*.id
}

output "igw_id"{
value = aws_internet_gateway.gw.id

}

output "peering_id"{
value = aws_vpc_peering_connection.roboshop_peering.id

}

output "publicRouteTable_id"{
value = aws_route_table.publicRoute.id

}

output "privateRouteTable_id"{
value = aws_route_table.privateRoute.id

}

output "natGateway_id"{
value = aws_nat_gateway.nat.id

}

