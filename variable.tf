/*Required variables*/

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}
variable "public_subnet" {
  type        = list(string)
  description = "CIDR for public subnets"
}

variable "private_subnet" {
  type        = list(string)
  description = "CIDR for private subnet"
}

variable "private_subnet_db" {
  type        = list(string)
  description = "cidr for db private subnet"
}

variable "azlist" {
  type        = list(string)
  description = "availability zone list where you want to deploy subnets"
}
