### ROLE ###

resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}


resource "aws_iam_role" "eks_node_role" {
  name               = "eks_node_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  ]
}


### IRSA ROLE ###

resource "aws_iam_role" "eddiecorp_eks_irsa_vpc_cni" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_vpc_cni.json
  name                = "eddiecorp_eks_irsa_vpc_cni"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

resource "aws_iam_role" "eddiecorp_eks_irsa_aws_lb_controller" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_aws_lb_controller.json
  name                = "eddiecorp_eks_irsa_aws_lb_controller"
  managed_policy_arns = [aws_iam_policy.aws_load_balancer_controller.arn]
}

resource "aws_iam_role" "eddiecorp_eks_irsa_external_dns" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_external_dns.json
  name                = "eddiecorp_eks_irsa_external_dns"
  managed_policy_arns = [aws_iam_policy.external_dns.arn]
}

resource "aws_iam_role" "eddiecorp_eks_irsa_cluster_autoscaler" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_cluster_autoscaler.json
  name                = "eddiecorp_eks_irsa_cluster_autoscaler"
  managed_policy_arns = [aws_iam_policy.cluster_autoscaler.arn]
}

resource "aws_iam_role" "eddiecorp_eks_irsa_efs_csi" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_efs_csi.json
  name                = "eddiecorp_eks_irsa_efs_csi"
  managed_policy_arns = [aws_iam_policy.efs_csi.arn]
}

resource "aws_iam_role" "eddiecorp_eks_irsa_ebs_csi" {
  assume_role_policy  = data.aws_iam_policy_document.eddiecorp_eks_irsa_ebs_csi.json
  name                = "eddiecorp_eks_irsa_ebs_csi"
  managed_policy_arns = [aws_iam_policy.ebs_csi.arn]
}


### ROLE POLICY DOCUMENT ###

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


### IRSA ROLE POLICY DOCUMENT ###

data "aws_iam_policy_document" "eddiecorp_eks_irsa_vpc_cni" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eddiecorp_eks_irsa_aws_lb_controller" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eddiecorp_eks_irsa_external_dns" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eddiecorp_eks_irsa_cluster_autoscaler" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eddiecorp_eks_irsa_efs_csi" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eddiecorp_eks_irsa_ebs_csi" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eddiecorp_eks.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eddiecorp_eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}


### POLICY ###

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = "aws_load_balancer_controller"
  policy = data.local_file.aws_load_balancer_controller.content
}

resource "aws_iam_policy" "external_dns" {
  name   = "external_dns"
  policy = data.aws_iam_policy_document.external_dns.json
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "cluster_autoscaler"
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_policy" "efs_csi" {
  name   = "efs_csi"
  policy = data.aws_iam_policy_document.efs_csi.json
}

resource "aws_iam_policy" "ebs_csi" {
  name   = "ebs_csi"
  policy = data.aws_iam_policy_document.ebs_csi.json
}


### POLICY DOCUMENT ###

# The IAM policy for the AWS Load Balancer Controller is published on it's GitHub. Since the policy document can change, it's easier to update it as a json file instead of a aws_iam_policy_document when a new version is published.
data "local_file" "aws_load_balancer_controller" {
  filename = "${path.module}/json/aws-lb-controller.json"
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "efs_csi" {
  statement {
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "elasticfilesystem:CreateAccessPoint",
      "elasticfilesystem:DeleteAccessPoint"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = [true]
    }
  }
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["ec2:CreateTags"]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "CreateVolume",
        "CreateSnapshot"
      ]
    }
  }
  statement {
    actions = ["ec2:DeleteTags"]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
  }
  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = [true]
    }
  }
  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }
  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }
  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = [true]
    }
  }
  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }
  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }
  statement {
    actions   = ["ec2:DeleteSnapshot"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }
  statement {
    actions   = ["ec2:DeleteSnapshot"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = [true]
    }
  }
}

### OIDC PROVIDER ###

data "tls_certificate" "eddiecorp_eks_certificate" {
  url = aws_eks_cluster.eddiecorp_eks.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eddiecorp_eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eddiecorp_eks_certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eddiecorp_eks.identity[0].oidc[0].issuer
}