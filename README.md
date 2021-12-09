# Eddiecorp Terraform Modules

## Usage guide

### Create a `terraform.tfvars` file

```bash
aws_region  = "us-east-1"
aws_account = "123456789012"
```

### Configure EKS settings on `main.tf` file

```terraform
module "dev_eks" {
  source = "./eks-public"

  ...

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

module "stg_eks" {
  source = "./eks-public"

  ...

  vpc_cidr = "172.19.0.0/16"
  eks_settings = ({
    cluster_name       = "stg_eks"
    cluster_version    = "1.21"
    vpc_cni_version    = "v1.10.1-eksbuild.1"
    kube_proxy_version = "v1.21.2-eksbuild.2"
    coredns_version    = "v1.8.4-eksbuild.1"
    ami_type           = "BOTTLEROCKET_x86_64"
    instance_types     = ["m5a.large", "m5.large"]
    allowed_ips        = ["0.0.0.0/0"]
  })
}
```

### To create MULTI-CLUSTER IRSAs

1. Create the IAM Role Policy Document in the file `eks-public/irsa-assume-policy.tf`. Follow the example bellow and replace the **<NAMESPACE>** and **<SERVICEACCOUNT>** fields on UPPERCASE:
```terraform
data "aws_iam_policy_document" "eks_irsa_aws_lb_controller" {
  statement {
    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_cluster.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:<NAMESPACE>:<SERVICEACCOUNT>"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}
```

2. Create an IAM Policy in the file `eks-public/irsa-policy.tf`. Follow the examples bellow for a external JSON file using `local_file` or as a terraform data using `aws_iam_policy_document`:
```terraform
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
```

3. Finally, create the IAM Role in the file `eks-public/irsa-role.tf`. Follow one the examples bellow for `local_file` or `aws_iam_policy_document`:
```terraform
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
```

### To create SINGLE-CLUSTER IRSAs

1. Follow the steps 1 and 2 from the previous guide for MULTI-CLUSTER IRSAs.

2. Create the IAM Role as in step 3 from the previous guide for MULTI-CLUSTER IRSAs, but add a count condition to only create the resource for a matching EKS Cluster name. Follow one of the examples bellow:
```terraform
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
```