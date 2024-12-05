variable "name" {
  type = string
  description = "name of the graphana workspace" 
}

variable "group_id" {
  type = string
  description = "The AWS SSO group ids to be assigned the role given in role"
}
