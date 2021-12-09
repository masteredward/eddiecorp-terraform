module "iam" {
  source = "./iam"
}

module "kms" {
  source      = "./kms"
  aws_account = var.aws_account
}

module "ec2" {
  source                             = "./ec2"
  autoscaler_disk_encryption_key_arn = module.kms.autoscaler_disk_encryption_key_arn
}

# module "prd_eks" {
#   source                          = "./eks-public"

#   aws_region                      = var.aws_region
#   eks_cluster_role_arn            = module.iam.eks_cluster_role_arn
#   eks_node_role_arn               = module.iam.eks_node_role_arn
#   secrets_encryption_key_arn      = module.kms.secrets_encryption_key_arn
#   launch_template_secure_eks_node = module.ec2.launch_template_secure_eks_node

#   vpc_cidr      = "172.17.0.0/16"
#   eks_settings = ({
#     cluster_name       = "prd_eks"
#     cluster_version    = "1.21"
#     vpc_cni_version    = "v1.10.1-eksbuild.1"
#     kube_proxy_version = "v1.21.2-eksbuild.2"
#     coredns_version    = "v1.8.4-eksbuild.1"
#     ami_type           = "BOTTLEROCKET_x86_64"
#     instance_types     = ["m5a.large", "m5.large"]
#     allowed_ips        = ["0.0.0.0/0"]
#   })
# }

module "dev_eks" {
  source = "./eks-public"

  aws_region                      = var.aws_region
  eks_cluster_role_arn            = module.iam.eks_cluster_role_arn
  eks_node_role_arn               = module.iam.eks_node_role_arn
  secrets_encryption_key_arn      = module.kms.secrets_encryption_key_arn
  launch_template_secure_eks_node = module.ec2.launch_template_secure_eks_node

  vpc_cidr = "172.18.0.0/16"
  eks_settings = ({
    cluster_name       = "dev_eks"
    cluster_version    = "1.21"
    vpc_cni_version    = "v1.10.1-eksbuild.1"
    kube_proxy_version = "v1.21.2-eksbuild.2"
    coredns_version    = "v1.8.4-eksbuild.1"
    ami_type           = "BOTTLEROCKET_x86_64"
    instance_types     = ["m5a.large", "m5.large"]
    allowed_ips        = ["0.0.0.0/0"]
  })
}