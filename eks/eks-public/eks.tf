### EKS CLUSTER ###

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_settings.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.eks_settings.cluster_version
  encryption_config {
    provider {
      key_arn = var.secrets_encryption_key_arn
    }
    resources = ["secrets"]
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id,
      aws_subnet.subnet_c.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eks_settings.allowed_ips
  }
  tags = {
    Name          = var.eks_settings.cluster_name
    "auto-delete" = "no"
  }
}

### EKS ADDONS ###

resource "aws_eks_addon" "eks_addon_vpc_cni" {
  cluster_name             = aws_eks_cluster.eks_cluster.name
  addon_name               = "vpc-cni"
  addon_version            = var.eks_settings.vpc_cni_version
  service_account_role_arn = aws_iam_role.eks_irsa_vpc_cni.arn
  resolve_conflicts        = "OVERWRITE"
}

resource "aws_eks_addon" "eks_addon_kube_proxy" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  addon_name        = "kube-proxy"
  addon_version     = var.eks_settings.kube_proxy_version
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "eks_addon_coredns" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  addon_name        = "coredns"
  addon_version     = var.eks_settings.coredns_version
  resolve_conflicts = "OVERWRITE"
  depends_on = [
    aws_eks_node_group.eks_nodegroup_a,
    aws_eks_node_group.eks_nodegroup_b,
    aws_eks_node_group.eks_nodegroup_c
  ]
}


### MANAGED NODE GROUPS ###

resource "aws_eks_node_group" "eks_nodegroup_a" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_settings.cluster_name}_nodegroup_a"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [aws_subnet.subnet_a.id]
  ami_type        = var.eks_settings.ami_type
  instance_types  = var.eks_settings.instance_types
  launch_template {
    id      = var.launch_template_secure_eks_node.id
    version = var.launch_template_secure_eks_node.version
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
    aws_eks_addon.eks_addon_vpc_cni,
    aws_eks_addon.eks_addon_kube_proxy
  ]
}

resource "aws_eks_node_group" "eks_nodegroup_b" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_settings.cluster_name}_nodegroup_b"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [aws_subnet.subnet_b.id]
  ami_type        = var.eks_settings.ami_type
  instance_types  = var.eks_settings.instance_types
  launch_template {
    id      = var.launch_template_secure_eks_node.id
    version = var.launch_template_secure_eks_node.version
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
    aws_eks_addon.eks_addon_vpc_cni,
    aws_eks_addon.eks_addon_kube_proxy
  ]
}

resource "aws_eks_node_group" "eks_nodegroup_c" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_settings.cluster_name}_nodegroup_c"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [aws_subnet.subnet_c.id]
  ami_type        = var.eks_settings.ami_type
  instance_types  = var.eks_settings.instance_types
  launch_template {
    id      = var.launch_template_secure_eks_node.id
    version = var.launch_template_secure_eks_node.version
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
    aws_eks_addon.eks_addon_vpc_cni,
    aws_eks_addon.eks_addon_kube_proxy
  ]
}