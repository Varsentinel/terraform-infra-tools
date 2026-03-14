variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "instance_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "subnet_cidr_block" {
  type = string
}

variable "volume_size" {
  type = number
}