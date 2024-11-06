variable "ami_id" {
  default = "ami-0ddc798b3f1a5117e"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "vpc_id" {
  type = string
}
variable "security_group_id" {
  type = string
}
variable "public_subnet_id" {
  type = string
}
variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}
