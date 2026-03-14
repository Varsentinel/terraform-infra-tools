module "ec2-delegate" {
  source  = "app.terraform.io/Varsentinel/ec2-delegate/aws"
  version = "1.0.0"
  # insert required variables here
  region            = var.region
  volume_size       = var.volume_size
  cidr_block        = var.cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  vpc_name          = var.vpc_name
  name              = var.instance_name
}