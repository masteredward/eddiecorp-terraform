resource "aws_iam_role" "eks_irsa_aws_lb_controller" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_aws_lb_controller.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_aws_lb_controller"
  inline_policy {
    name   = "aws_load_balancer_controller"
    policy = data.local_file.aws_load_balancer_controller.content
  }
}

resource "aws_iam_role" "eks_irsa_external_dns" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_external_dns.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_external_dns"
  inline_policy {
    name   = "external_dns"
    policy = data.aws_iam_policy_document.external_dns.json
  }
}

resource "aws_iam_role" "eks_irsa_cluster_autoscaler" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_cluster_autoscaler.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_cluster_autoscaler"
  inline_policy {
    name   = "cluster_autoscaler"
    policy = data.aws_iam_policy_document.cluster_autoscaler.json
  }
}

resource "aws_iam_role" "eks_irsa_efs_csi" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_efs_csi.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_efs_csi"
  inline_policy {
    name   = "efs_csi"
    policy = data.aws_iam_policy_document.efs_csi.json
  }
}

resource "aws_iam_role" "eks_irsa_ebs_csi" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_ebs_csi.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_ebs_csi"
  inline_policy {
    name   = "ebs_csi"
    policy = data.aws_iam_policy_document.ebs_csi.json
  }
}

resource "aws_iam_role" "eks_irsa_amazon_cloudwatch" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_amazon_cloudwatch.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_amazon_cloudwatch"
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}


### SINGLE-CLUSTER ROLE ###

resource "aws_iam_role" "eks_irsa_test_role_dev" {
  count = "${aws_eks_cluster.eks_cluster.name == "dev_eks" ? 1 : 0}"
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_test_role.json
  name                = "${aws_eks_cluster.eks_cluster.name}_test_role"
}

resource "aws_iam_role" "eks_irsa_test_role_stg" {
  count = "${aws_eks_cluster.eks_cluster.name == "stg_eks" ? 1 : 0}"
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_test_role.json
  name                = "${aws_eks_cluster.eks_cluster.name}_test_role"
}

resource "aws_iam_role" "eks_irsa_test_role_prd" {
  count = "${aws_eks_cluster.eks_cluster.name == "prd_eks" ? 1 : 0}"
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_test_role.json
  name                = "${aws_eks_cluster.eks_cluster.name}_test_role"
}

resource "aws_iam_role" "eks_irsa_secret_test_dev" {
  count = "${aws_eks_cluster.eks_cluster.name == "dev_eks" ? 1 : 0}"
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_secret_test.json
  name                = "${aws_eks_cluster.eks_cluster.name}_secret_test"
}