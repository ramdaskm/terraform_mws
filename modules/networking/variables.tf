variable "prefix" {
  description = "Prefix to prepend"
}


variable "common_prefix" {
  type        = string
  description = "Common prefix for public resources"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}


variable "tags" {
  type        = map(string)
  description = "tags"
}


variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

