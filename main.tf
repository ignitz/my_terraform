module "instances" {
  source = "./modules/ec2"

  vpc_id    = module.vpc.vpc_id
  key_name  = module.key_pair.key_name
  subnet_id = module.vpc.subnet_public
}

module "key_pair" {
  source = "./modules/key_pair"

  key_name = "yuriniitsuma"
}

module "vpc" {
  source = "./network/"
}
