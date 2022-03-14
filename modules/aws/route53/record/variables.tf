variable "zone_id" {
  type = string
}

variable "address" {
  type = string
}

variable "type" {
  type = string
  default = "A"
}

variable "ttl" {
  type = string
  default = "300"
}

variable "proxy_target" {
  type = string
}
