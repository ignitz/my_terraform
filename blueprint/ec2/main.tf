# aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"

resource "aws_instance" "ubuntumachine" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }

  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data

  subnet_id = var.subnet_id

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 50
  }
}

# Get the latest Ubuntu 18.04
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
