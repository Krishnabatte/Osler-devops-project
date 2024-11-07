variable "vpc_id" {
  description = "The VPC ID where the Internet Gateway will be attached."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}
