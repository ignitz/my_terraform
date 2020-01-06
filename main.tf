module "instances" {
  source = "./modules/ec2"
}

module "vpc" {
  source = "./network/"
}

# module "test" {
#   source = "./test/"
# }

output "public_address" {
  value = module.instances.ec2_public_dns
}
