output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw" {
  value = aws_internet_gateway.ig.id
}

output "nat" {
  value = aws_nat_gateway.nat.id
}

output "eip" {
  value = aws_eip.nat_eip.id
}

output "sg_id" {
  value = "${aws_security_group.default.id}"
}

output "public_subnets_id" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets_id" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "route_table_public" {
  value = aws_route_table.public.id
}

