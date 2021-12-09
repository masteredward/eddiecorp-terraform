output "eks_networking" {
  value = ({
    vpc    = aws_vpc.vpc
    subnet_a = aws_subnet.subnet_a
    subnet_b = aws_subnet.subnet_b
    subnet_c = aws_subnet.subnet_c
  })
}

output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster
}