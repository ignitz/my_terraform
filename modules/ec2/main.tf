resource "aws_instance" "mymachine" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Yuri Niitsuma Instance"
  }

  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_http.name]
  user_data       = file("./modules/ec2/user_data.sh")
}

resource "aws_key_pair" "my_key" {
  key_name   = "mymachine"
  public_key = file("./keys/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "allow_http" {
  name = "allow_http"

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

output "ec2_public_dns" {
  value = aws_instance.mymachine.public_ip
}
