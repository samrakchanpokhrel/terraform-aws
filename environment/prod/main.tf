
data "aws_caller_identity" "current" {}

locals {
  ami_id                  = "ami-0c7217cdde317cfec"
  account_id              = data.aws_caller_identity.current.account_id
  ec2_name                = "demo"
  ec2_security_group_name = "sg-ec2"
  environment             = "dev"
}
##########################################################################################
# Create EC2
##########################################################################################
module "ec2" {
  source                  = "../../Module/ec2"
  ec2_instance_name       = join("-", ["sam",local.ec2_name])
  ec2_instance_type       = "t2.micro"
  ami_id                  = local.ami_id
  ec2_security_group_name = join("-", ["sam",local.ec2_name])
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.vpc.pub_subnet_id[0]
  key_name                = aws_key_pair.default.id
  userdata = file("${path.module}/start-master.sh")
  ec2_cidr_blocks = [""]
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = local.ec2_name
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "aws_secretsmanager_secret" "key_pair" {
  name = "kk"
}
resource "aws_secretsmanager_secret_version" "key_pair_json" {
  secret_id = aws_secretsmanager_secret.key_pair.id
  secret_string = jsonencode({
    "private_key" : tls_private_key.ec2.private_key_pem
    "public_key" : tls_private_key.ec2.public_key_pem
  })
}

module "vpc" {
  source      = "../../Module/vpc"
  environment = local.environment
  vpc_cidr    = var.vpc_cidr
}

module "cloudwatch" {
  source       = "../../Module/cloudwatch"
  ec2-instance = join("-", ["sam",local.ec2_name])
}

