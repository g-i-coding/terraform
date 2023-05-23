variable "default_tags" {
  type = map(string)
  default = {
    "env" = "celzey-terraform"
  }
  description = "Describing my resource"
}

variable "public_subnet_count" {
  type        = number
  description = "number of public subnets"
  default     = 2
}

variable "private_subnet_count" {
  type        = number
  description = "number of private subnets"
  default     = 2
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block"
  default     = "99.88.0.0/16"
}

variable "sg_db_ingress" {
  type = map(object({
    port     = number
    protocol = string
    self     = bool
  }))
  default = {
    mysql = {
      port     = 3306
      protocol = "tcp"
      self     = true
    }
  }
}
variable "sg_db_egress" {
  type = map(object({
    port     = number
    protocol = string
    self     = bool
  }))
  default = {
    all = {
      port     = 0
      protocol = "-1"
      self     = true
    }
  }

}



