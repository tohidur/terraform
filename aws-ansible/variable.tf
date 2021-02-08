variable "region" {
  default = "ap-south-1"
}

variable "aws_ubuntu_amis" {
  default = {
    "ap-south-1": "ami-23443434"
  }
}

variable "environment" {
  type = "string"
}

variable "application" {
  type = "string"
}

variable "key_name" {
  type = "string"
  default = "ec2Key"
}

variable "mgmt_ips" {
  default = ["0.0.0.0/0"]
}
