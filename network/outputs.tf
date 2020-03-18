output "subnet_public" {
  value = aws_subnet.public[0].id
}

output "subnet_private" {
  value = aws_subnet.private[0].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}
