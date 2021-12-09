provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        aws_eks_cluster.eks_cluster.name,
        "--region",
        var.aws_region
      ]
      command = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.eks_cluster.name,
      "--region",
      var.aws_region
    ]
    command = "aws"
  }
}