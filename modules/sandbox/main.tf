# aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"
module "ec2" {
  source = "../../blueprint/ec2"

  instance_name          = "${var.project_name}-${var.env_name}-Sandbox"
  instance_type          = "t3a.micro"
  key_name               = var.key_name
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = data.template_file.user_data.rendered
}


data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    HOME                = "/home/ubuntu"
    ANACONDA            = "https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh"
    CODESERVER_PASSWORD = var.password
    PORTAINER_USERNAME  = var.password
    PORTAINER_PASSWORD  = var.password
    JUPYTER_PASSWORD    = var.password
  }
}

resource "aws_security_group" "sg" {
  name = "${var.project_name}-${var.env_name}-Sandbox SG"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}
