### EKS CLUSTER ###

resource "aws_eks_cluster" "eddiecorp_eks" {
  name     = "eddiecorp_eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.21"
  encryption_config {
    provider {
      key_arn = aws_kms_key.general_purpose_symmetric.arn
    }
    resources = ["secrets"]
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.eddiecorp_eks_subnet_a.id,
      aws_subnet.eddiecorp_eks_subnet_b.id,
      aws_subnet.eddiecorp_eks_subnet_c.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eddiecorp_eks_allowed_ips
  }
  tags = {
    Name          = "eddiecorp_eks"
    "auto-delete" = "no"
  }
}


### EKS ADDONS ###

resource "aws_eks_addon" "eddiecorp_eks_addon_vpc_cni" {
  cluster_name             = aws_eks_cluster.eddiecorp_eks.name
  addon_name               = "vpc-cni"
  addon_version            = "v1.9.3-eksbuild.1"
  service_account_role_arn = aws_iam_role.eddiecorp_eks_irsa_vpc_cni.arn
  resolve_conflicts        = "OVERWRITE"
}

resource "aws_eks_addon" "eddiecorp_eks_addon_kube_proxy" {
  cluster_name      = aws_eks_cluster.eddiecorp_eks.name
  addon_name        = "kube-proxy"
  addon_version     = "v1.21.2-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "eddiecorp_eks_addon_coredns" {
  cluster_name      = aws_eks_cluster.eddiecorp_eks.name
  addon_name        = "coredns"
  addon_version     = "v1.8.4-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  depends_on = [
    aws_eks_node_group.eddiecorp_eks_nodegroup_a,
    aws_eks_node_group.eddiecorp_eks_nodegroup_b,
    aws_eks_node_group.eddiecorp_eks_nodegroup_c
  ]
}


### MANAGED NODE GROUPS ###

resource "aws_eks_node_group" "eddiecorp_eks_nodegroup_a" {
  cluster_name    = aws_eks_cluster.eddiecorp_eks.name
  node_group_name = "eddiecorp_eks_nodegroup_a"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.eddiecorp_eks_subnet_a.id]
  ami_type        = "BOTTLEROCKET_ARM_64"
  instance_types = [
    "m6g.medium"
  ]
  launch_template {
    id      = aws_launch_template.secure_eks_node.id
    version = aws_launch_template.secure_eks_node.latest_version
  }
  capacity_type        = "SPOT"
  force_update_version = true
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  depends_on = [
    aws_eks_addon.eddiecorp_eks_addon_vpc_cni,
    aws_eks_addon.eddiecorp_eks_addon_kube_proxy
  ]
}

resource "aws_eks_node_group" "eddiecorp_eks_nodegroup_b" {
  cluster_name    = aws_eks_cluster.eddiecorp_eks.name
  node_group_name = "eddiecorp_eks_nodegroup_b"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.eddiecorp_eks_subnet_b.id]
  ami_type        = "BOTTLEROCKET_ARM_64"
  instance_types = [
    "m6g.medium"
  ]
  launch_template {
    id      = aws_launch_template.secure_eks_node.id
    version = aws_launch_template.secure_eks_node.latest_version
  }
  capacity_type        = "SPOT"
  force_update_version = true
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  depends_on = [
    aws_eks_addon.eddiecorp_eks_addon_vpc_cni,
    aws_eks_addon.eddiecorp_eks_addon_kube_proxy
  ]
}

resource "aws_eks_node_group" "eddiecorp_eks_nodegroup_c" {
  cluster_name    = aws_eks_cluster.eddiecorp_eks.name
  node_group_name = "eddiecorp_eks_nodegroup_c"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.eddiecorp_eks_subnet_c.id]
  ami_type        = "BOTTLEROCKET_ARM_64"
  instance_types = [
    "m6g.medium"
  ]
  launch_template {
    id      = aws_launch_template.secure_eks_node.id
    version = aws_launch_template.secure_eks_node.latest_version
  }
  capacity_type        = "SPOT"
  force_update_version = true
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  depends_on = [
    aws_eks_addon.eddiecorp_eks_addon_vpc_cni,
    aws_eks_addon.eddiecorp_eks_addon_kube_proxy
  ]
}


### LAUNCH TEMPLATES ###

resource "aws_launch_template" "secure_eks_node" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 2
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.asg_ebs_symmetric.arn
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.asg_ebs_symmetric.arn
      delete_on_termination = true
    }
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}