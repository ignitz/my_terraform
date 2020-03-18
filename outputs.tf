output "generated_password" {
  value       = fileexists("${path.module}/infra.json") ? jsondecode(file("${path.module}/infra.json")).generated_password.value : random_password.password.result
  description = "Automatic password generated, copy to a safe place and run:\naws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data \":\""
}

# output "sandbox" {
#   value = {
#     instance_id = module.nginx.sandbox.ec2_instance_id
#   }
#   description = "The public IP address of Nginx instance machine."
# }

# output "nginx" {
#   value = {
#     instance_id = module.nginx.ec2.ec2_instance_id
#     public_ip   = module.nginx.ec2.public_ip
#   }
#   description = "The public IP address of my instance machine."
# }
