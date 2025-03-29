provider "aws" {
  region = var.region
}
resource "aws_security_group" "cba_tf_sg" {
  name        = "cba_tf_sg"
  description = "allow all traffic"
  # data "aws_vpc" "default" {
  # default = true
  #}
  # vpc_id      = data.aws_vpc.default.id
  #vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "CBAterraformSG"
  }
}
data "aws_key_pair" "sample_kp" {
  key_name = var.key_name
}
resource "aws_instance" "cba_tf_instance" {
  instance_type   = var.instance_type
  security_groups = [aws_security_group.cba_tf_sg.name]
  ami             = var.instance_ami
  key_name        = var.key_name
  user_data       = file("install_apache.sh")
  tags = {
    Name = "CBATerraformInstance"
  }
}
