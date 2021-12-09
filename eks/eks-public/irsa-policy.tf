data "local_file" "aws_load_balancer_controller" {
  filename = "${path.module}/policy/aws-lb-controller.json"
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