provider "aws" {
  region = var.region
}
resource "aws_vpc" "EKS_VPC" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames =  true
    enable_dns_support = true
    tags = {
      Name = "${var.project}-vpc"
    }
}
