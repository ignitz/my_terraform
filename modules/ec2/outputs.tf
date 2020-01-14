output "ec2_public_dns" {
  value = aws_instance.mymachine.public_ip
}

output "ec2_instance_id" {
  value       = aws_instance.mymachine.id
  description = "ID of created machine."
}

