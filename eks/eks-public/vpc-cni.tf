resource "aws_iam_role" "eks_irsa_vpc_cni" {
  assume_role_policy  = data.aws_iam_policy_document.eks_irsa_vpc_cni.json
  name                = "${aws_eks_cluster.eks_cluster.name}_irsa_vpc_cni"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

data "aws_iam_policy_document" "eks_irsa_vpc_cni" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_cluster.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}