output "sandbox" { value = module.ec2 }
output "private_ip" { value = module.ec2.ec2.private_ip }
