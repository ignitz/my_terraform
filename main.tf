module "instances" {
  source = "./modules/ec2"

  instance_name       = var.instance_name
  vpc_id              = module.vpc.vpc_id
  key_name            = module.key_pair.key_name
  subnet_id           = module.vpc.subnet_public
  codeserver_password = random_password.password.result
  portainer_username  = "admin"
  portainer_password  = random_password.password.result
  jupyter_password    = random_password.password.result
}

module "key_pair" {
  source = "./modules/key_pair"

  key_name = "yuriniitsuma"
}

module "vpc" {
  source = "./network/"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
