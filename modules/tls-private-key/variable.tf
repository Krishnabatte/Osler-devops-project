# modules/tls-private-key/variables.tf
variable "key_name" {
  description = "The name of the EC2 key pair"
  type        = string
}