# resource "helm_release" "prod_eks_aws_lb_controller" {
#   provider   = helm
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts/"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
#   }
#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.eks_cluster.name
#   }
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.eks_irsa_aws_lb_controller.arn
#   }
#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#   set {
#     name  = "region"
#     value = var.aws_region
#   }
#   set {
#     name  = "vpcId"
#     value = aws_vpc.vpc.id
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns
#   ]
# }

# resource "helm_release" "eks_metrics_server" {
#   provider   = helm
#   name       = "metrics-server"
#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns
#   ]
# }

# resource "helm_release" "eks_external_dns" {
#   provider   = helm
#   name       = "external-dns"
#   repository = "https://kubernetes-sigs.github.io/external-dns/"
#   chart      = "external-dns"
#   namespace  = "kube-system"
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.eks_irsa_external_dns.arn
#   }
#   set {
#     name  = "serviceAccount.name"
#     value = "external-dns"
#   }
#   set {
#     name  = "policy"
#     value = "sync"
#   }
#   set {
#     name  = "txtOwnerId"
#     value = aws_eks_cluster.eks_cluster.name
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns
#   ]
# }

# resource "helm_release" "eks_efs_csi" {
#   provider   = helm
#   name       = "aws-efs-csi-driver"
#   repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
#   chart      = "aws-efs-csi-driver"
#   namespace  = "kube-system"
#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/eks/aws-efs-csi-driver"
#   }
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.eks_irsa_efs_csi.arn
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns
#   ]
# }

# resource "helm_release" "eks_cluster_autoscaler" {
#   provider   = helm
#   name       = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler/"
#   chart      = "cluster-autoscaler"
#   namespace  = "kube-system"
#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.eks_irsa_cluster_autoscaler.arn
#   }
#   set {
#     name  = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler"
#   }
#   set {
#     name  = "autoDiscovery.clusterName"
#     value = aws_eks_cluster.eks_cluster.name
#   }
#   set {
#     name  = "awsRegion"
#     value = var.aws_region
#   }
#   set {
#     name  = "extraArgs.logtostderr"
#     value = true
#   }
#   set {
#     name  = "extraArgs.stderrthreshold"
#     value = "info"
#   }
#   set {
#     name  = "extraArgs.v"
#     value = 4
#   }
#   set {
#     name  = "extraArgs.skip-nodes-with-local-storage"
#     value = false
#   }
#   set {
#     name  = "extraArgs.expander"
#     value = "least-waste"
#   }
#   set {
#     name  = "extraArgs.balance-similar-node-groups"
#     value = true
#   }
#   set {
#     name  = "extraArgs.skip-nodes-with-system-pods"
#     value = false
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns
#   ]
# }

# resource "helm_release" "argo_cd" {
#   provider   = helm
#   name       = "argo-cd"
#   repository = "https://argoproj.github.io/argo-helm/"
#   chart      = "argo-cd"
#   namespace  = "argo-cd"
#   set {
#     name  = "redis-ha.enabled"
#     value = true
#   }
#   set {
#     name  = "controller.enableStatefulSet"
#     value = true
#   }
#   set {
#     name  = "server.autoscaling.enabled"
#     value = true
#   }
#   set {
#     name  = "server.autoscaling.minReplicas"
#     value = 2
#   }
#   set {
#     name  = "repoServer.autoscaling.enabled"
#     value = true
#   }
#   set {
#     name  = "repoServer.autoscaling.minReplicas"
#     value = 2
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c,
#     aws_eks_addon.eks_addon_coredns,
#     kubernetes_manifest.ns_argo_cd
#   ]
# }