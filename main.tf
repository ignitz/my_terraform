module "sandbox" {
  source = "./modules/sandbox"

  project_name = var.project_name
  env_name     = var.env_name
  vpc_id       = module.vpc.vpc_id
  key_name     = module.key_pair.key_name
  subnet_id    = module.vpc.subnet_private
  password     = fileexists("${path.root}/infra.json") ? jsondecode(file("${path.root}/infra.json")).generated_password.value : random_password.password.result

  cidr_block = module.vpc.cidr_block
}

module "nginx" {
  source = "./modules/nginx"

  project_name = var.project_name
  env_name     = var.env_name
  vpc_id       = module.vpc.vpc_id
  key_name     = module.key_pair.key_name
  subnet_id    = module.vpc.subnet_public
  password     = fileexists("${path.root}/infra.json") ? jsondecode(file("${path.root}/infra.json")).generated_password.value : random_password.password.result

  jupyter_host = module.sandbox.private_ip
}

# Key pair to connect in EC2 instances
module "key_pair" {
  source = "./modules/key_pair"

  key_name = "${var.key_name}"
}

module "vpc" {
  source = "./network/"
}

# Generate a random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
