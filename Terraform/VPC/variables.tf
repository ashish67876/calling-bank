variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}
variable "project" {
    description = "the project name"
    type = string
  
}
 variable "vpc_cidr" {
    description = "cidr block for vpc"
    type = string
   
 }