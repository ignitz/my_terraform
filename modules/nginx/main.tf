module "ec2" {
  source = "../../blueprint/ec2"

  instance_name          = "${var.project_name}-${var.env_name}-Nginx"
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
    HOME        = "/home/ubuntu"
    JupyterHOST = var.jupyter_host
    EC2HOST     = var.jupyter_host
    USERNAME    = "admin"
    PASSWORD    = var.password
  }
}

resource "aws_security_group" "sg" {
  name = "${var.project_name}-${var.env_name}-Nginx-SG"

  vpc_id = var.vpc_id

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
}
