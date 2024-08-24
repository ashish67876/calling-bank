variable "name_prefix" {
    description = "cluster role name"
    type = string
}
variable "tags" {
    description = "Tags name"
    type = map(string)
    default = {}
  
}
