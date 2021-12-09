# variable "ssh_allowed_ips" {
#   type = list(string)
# }

variable "aws_region" {
  type = string
}

variable "aws_account" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "eddiecorp_eks_allowed_ips" {
  type = list(string)
}

variable "eddiecorp_eks_vpc_cidr" {
  type = string
}

variable "eddiecorp_eks_subnet_a_cidr" {
  type = string
}

variable "eddiecorp_eks_subnet_b_cidr" {
  type = string
}

variable "eddiecorp_eks_subnet_c_cidr" {
  type = string
}