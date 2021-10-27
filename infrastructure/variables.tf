#Default SSH Keys
variable "keyname_bastion"{
type = string
  default = "bastion"
}

variable "keyname_webserver"{
type = string
  default = "web-server"
}

#Default AWS Region where Resources are Deployed
variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

#Default 2 availability zones
variable "az1" {
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  type        = string
  default     = "us-east-1b"
}

#Default VPC CIDR Block
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc_cidr_block vpc_approach1"
}

#Default CIDR Blocks for Subnets
variable "private1a_cidr_block"{
   type        = string
   default     = "10.0.0.0/24"
}

variable "private1b_cidr_block"{
   type        = string
   default     = "10.0.1.0/24"
}
variable "public1a_cidr_block"{
   type        = string
   default     = "10.0.2.0/24"
}
variable "public1b_cidr_block"{
   type        = string
   default     = "10.0.3.0/24"
}

#SG ports to web servers from bastion server
variable "webserver_ports"{
   type        = list
   default     = ["22","-1"]
}