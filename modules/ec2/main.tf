# aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"

resource "aws_instance" "mymachine" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t3.large"

  tags = {
    Name = "Yuri Niitsuma Instance"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_mymachine.id]
  user_data              = data.template_file.user_data.rendered

  subnet_id = var.subnet_id
}

resource "aws_security_group" "allow_mymachine" {
  name = "allow_mymachine"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    HOME                = "/home/ubuntu"
    ANACONDA            = "https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh"
    CODESERVER_PASSWORD = var.codeserver_password
    PORTAINER_USERNAME  = var.portainer_username
    PORTAINER_PASSWORD  = var.portainer_password
    JUPYTER_PASSWORD    = var.jupyter_password
  }
}
