variable "name_prefix" {
    description = "Name of eks security group"
    type = string
  
}
variable "vpc_id" {
    description = "vpc id get from vpc module"
    type = string

}

variable "tags" {
    description = "tags name for sg"
    type = map(string)
    default = {}
  
}