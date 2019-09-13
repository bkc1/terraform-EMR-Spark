variable "public_key_path" {
  description = "Enter path to the public key"
  default     = "keys/mykey.pub"
}

variable "key_name" {
  description = "Enter name of private key"
  default     = "mykey"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "us-east-2"
}

variable "app_prefix" {
  description = "Application abbreviation/prefix"
  default     = "myapp"
}

variable "env" {
  default = "sandbox"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/21"
}

variable "subnet1" {
  default = "10.0.1.0/24"
}

variable "subnet2" {
  default = "10.0.2.0/24"
}
