output "ec2_instance_id" {
  value = module.instances.ec2_instance_id
}

output "public_address" {
  value       = module.instances.ec2_public_dns
  description = "The public IP address of my instance machine."
}

output "generated_password" {
  value       = random_password.password.result
  description = "Automatic password generated, copy to a safe place and run:\naws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data \":\""
}
