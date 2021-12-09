resource "aws_launch_template" "secure_eks_node" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 2
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.autoscaler_disk_encryption_key_arn
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = var.autoscaler_disk_encryption_key_arn
      delete_on_termination = true
    }
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  user_data = filebase64("${path.module}/bottlerocket/userdata.toml")
}