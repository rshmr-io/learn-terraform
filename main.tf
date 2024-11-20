data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.blog_sg.id]

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "blog_sg" {
  name = "blog_sg"
  description = "blog security group"
  vpc_id = data.aws_vpc.default.id

  tags {
    Name = "blog"
  }
}

resource "aws_security_group_rule" "http_inbound" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog_sg.id
}

resource "aws_security_group_rule" "http_outbound" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog_sg.id
}

