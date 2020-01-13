output "ec2_public_dns" {
  value = aws_instance.mymachine.public_ip
}

