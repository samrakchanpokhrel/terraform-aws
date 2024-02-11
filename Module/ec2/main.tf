
resource "aws_iam_instance_profile" "ec2" {
  name = var.ec2_instance_name
  role = aws_iam_role.default.name
}
data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}
resource "aws_iam_role" "default" {

  name               = "ec2_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.default.json
}


resource "aws_iam_role_policy_attachment" "cloud_watch_agent_server_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.default.name
}

resource "aws_security_group" "ec2" {
  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }	

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = "ami-0c7217cdde317cfec"#var.ami_id 
  instance_type          = "t2.micro"#var.ec2_instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  # ebs_optimized          = var.ebs_optimized
#   user_data              = var.userdata
  tags = {
    Name    = var.ec2_instance_name
    Project = var.tags.Project
  }

  root_block_device {
    volume_size           = var.ec2_volume_size
    delete_on_termination = true
  }
  # iam_instance_profile = aws_iam_instance_profile.ec2.name
}
# resource "aws_eip" "elastic_ip" {
#   tags = {
#     Name    = var.ec2_instance_name
#     Project = var.tags.Project
#   }
#   instance = aws_instance.ec2.id
#   vpc      = true
# }