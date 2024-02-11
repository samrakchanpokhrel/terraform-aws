# data "aws_iam_role" "ec2" {
#   name               = ""
# }
data "aws_caller_identity" "current" {}

locals {
  ami_id     = "ami-0fcf52bcf5db7b003"
  account_id = data.aws_caller_identity.current.account_id
  ec2_name   = "demo" 
  ec2_security_group_name = "sg-ec2"
  environment = "dev"
}
##########################################################################################
# Create EC2
##########################################################################################
module "ec2" {
  source                  = "../../Module/ec2"
  ec2_instance_name       = join("sam",[local.ec2_name])
  ec2_instance_type       = "t2.micro"
  ami_id                  = local.ami_id
  ec2_security_group_name = join("sam", [local.ec2_name, 1])
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.vpc.pub_subnet_id[0]
  key_name                = aws_key_pair.default.id
  # ec2_role                = aws_iam_role.default.name
   userdata                = file("${path.module}/start-master.sh")
#   image_owners            = local.account_id
  ec2_cidr_blocks         = [""]
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = local.ec2_name
  public_key = tls_private_key.ec2.public_key_openssh
}

module "vpc" {
  source = "../../Module/vpc"
  environment           = local.environment
  vpc_cidr              = var.vpc_cidr
  # pub_subnets_cidr      = var.pub_subnets_cidr
  # private_subnets_cidr  = var.private_subnets_cidr
  # aws_region = "${var.aws_region}"
}

