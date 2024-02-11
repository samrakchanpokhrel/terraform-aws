output "out_vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "pub_subnet_id" {
  value = "${aws_subnet.pub_subnet.*.id}"
}