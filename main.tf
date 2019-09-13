# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "myapp" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

terraform {
  required_version = ">= 0.11.7"
}

