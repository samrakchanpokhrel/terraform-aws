
#Dynamic block
locals {
   ingress_rules = [{
      rule        = 100
      port        = 80
      description = "Ingress rules for port 80"
   },
   {
     rule        = 200
      port        = 22
      description = "Ingree rules for port 22"
   },
   {
     rule        = 300
      port        = 443
      description = "Ingree rules for port 433"
   }]
}
#================ VPC ================

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
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


#================ NACL ================
resource "aws_network_acl" "pub_nacl" {
  vpc_id = "${aws_vpc.vpc.id}"
  count          = "${length(var.pub_subnets_cidr)}"
  subnet_ids = [aws_subnet.pub_subnet[0].id]

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
