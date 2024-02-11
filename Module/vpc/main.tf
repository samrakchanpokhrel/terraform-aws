#================ VPC ================

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}




#================ IGW ================

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

#================ Public Subnet ================
 resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = "${length(var.pub_subnets_cidr)}"
  cidr_block              = "${element(var.pub_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.environment}-pub-subnet-${count.index}"
    Environment = var.environment
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "${var.environment}-aws_route_table"
    Environment = var.environment
  }
}

#================ Optional End ================

#================ Route Table Association ================
resource "aws_route_table_association" "pub_rtb_assoc" {
  count          = "${length(var.pub_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.pub_rtb.id
}


resource "aws_security_group" "default" {
  name        = join("-", ["vpc", "security-group"])
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "VPC Access"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_acl" "acl" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.pub_subnet[1].id]
  tags = {
    Name = "acl"
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
}
