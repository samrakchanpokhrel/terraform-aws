variable "aws_region" {
  default = "us-east-1"  
}
variable "availability_zones" {
  type    = list
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "VPC default CIDR"
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "VPC default instance_tenancy"
  default     = "dedicated"
}

variable "environment" {
  description = "default environment"
  default     = "sam"
}

variable "pub_subnets_cidr" {
  description = "list of public subnets"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}