resource "aws_eip" "gw" {
  count = var.az_count
  vpc   = true

  tags = {
    Environment = "Yuri Niitsuma"
  }
}

resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)


  tags = {
    Name = "Yuri Niitsuma NAT for private"
  }
}
