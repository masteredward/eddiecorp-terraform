output "launch_template_secure_eks_node" {
  value = ({
    id = aws_launch_template.secure_eks_node.id
    version = aws_launch_template.secure_eks_node.latest_version
  })
}