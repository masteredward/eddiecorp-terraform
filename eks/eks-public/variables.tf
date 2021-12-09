variable "aws_region" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_node_role_arn" {
  type = string
}

variable "eks_settings" {
  type = object({
    cluster_name = string
    cluster_version = string
    vpc_cni_version = string
    kube_proxy_version = string
    coredns_version = string
    ami_type = string
    instance_types = list(string)
    allowed_ips = list(string)
  })
}

variable "vpc_cidr" {
  type = string
}

variable "secrets_encryption_key_arn" {
  type = string
}

variable "launch_template_secure_eks_node" {
  type = object({
    id = string
    version = string
  })
}