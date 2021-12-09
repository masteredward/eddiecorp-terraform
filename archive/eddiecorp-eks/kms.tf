### KEY ###

resource "aws_kms_key" "general_purpose_symmetric" {
  deletion_window_in_days = 7
  multi_region            = true
}

resource "aws_kms_key" "asg_ebs_symmetric" {
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.asg_ebs_symmetric.json
  multi_region            = true
}


### ALIAS ###

resource "aws_kms_alias" "general_purpose_symmetric" {
  name          = "alias/general_purpose_symmetric"
  target_key_id = aws_kms_key.general_purpose_symmetric.key_id
}

resource "aws_kms_alias" "asg_ebs_symmetric" {
  name          = "alias/asg_ebs_symmetric"
  target_key_id = aws_kms_key.asg_ebs_symmetric.key_id
}


### POLICY ###

data "aws_iam_policy_document" "asg_ebs_symmetric" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }
}