variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "protocol" {
  type = string
  default = "-1"
}

variable "port" {
  type = string
}

variable "ip_v4_from" {
  type = list(string)
  default = []
}

variable "ip_v6_from" {
  type = list(string)
  default = []
}

variable "ip_v4_to" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "ip_v6_to" {
  type = list(string)
  default = ["::0/0"]
}
