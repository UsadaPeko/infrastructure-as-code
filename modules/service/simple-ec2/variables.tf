variable "name" {
  type = string
}

variable "ami" {
  type = string
  default = "ami-0454bb2fefc7de534"
}

variable "instance_type" {
  type = string
  default = "t3.nano"
}

variable "key_name" {
  type = string
  default = "Home"
}

variable "security_group_ids" {
  type = list ( string )
}
