resource "aws_eip" "nat_1c" {
  vpc = true

  tags = {
    Name = "handson-natgw-1c"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  subnet_id     = "${aws_subnet.public_1c.id}"
  allocation_id = "${aws_eip.nat_1c.id}"

  tags = {
    Name = "handson-1c"
  }
}

resource "aws_eip" "nat_1d" {
  vpc = true

  tags = {
    Name = "handson-natgw-1d"
  }
}

resource "aws_nat_gateway" "nat_1d" {
  subnet_id     = "${aws_subnet.public_1d.id}"
  allocation_id = "${aws_eip.nat_1d.id}"

  tags = {
    Name = "handson-1d"
  }
}
