variable "ec2_security_group_name" {
  type = string
}

variable "ec2_security_group_description" {
  type    = string
  default = "EC2 Security Group Managed By Terraform"
}

variable "vpc_id" {
  type = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}


variable "ec2_cidr_blocks" {
  type = list(string)
#   default = ["" ]
}

variable "virtualization_filter_values" {
  type    = list(string)
  default = ["hvm"]
}

variable "tags" {
  type = map(string)
  default = {
    Name    = "samrakchan"
    Project = "samrakchan"
  }
}

variable "ec2_instance_name" {
  type = string
}

variable "ec2_volume_size" {
  type    = string
  default = 8
}

variable "ami_id" {
  type    = string
  default = "ami-0c7217cdde317cfec"
}

variable "key_name" {
  type = string
}

variable "userdata" {
  type    = string
  default = ""
}

variable "ebs_optimized" {
  type    = bool
  default = false
}
