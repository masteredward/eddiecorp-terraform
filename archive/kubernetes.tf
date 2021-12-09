# resource "kubernetes_manifest" "ns_argo_cd" {
#   manifest = {
#     "apiVersion" = "v1"
#     "kind" = "Namespace"
#     "metadata" = {
#       "name" = "argo-cd"
#     }
#   }
#   depends_on = [
#     aws_eks_node_group.eks_nodegroup_a,
#     aws_eks_node_group.eks_nodegroup_b,
#     aws_eks_node_group.eks_nodegroup_c
#   ]
# }