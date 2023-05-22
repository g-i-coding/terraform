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


