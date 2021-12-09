output "secrets_encryption_key_arn" {
  value = aws_kms_key.general_purpose_symmetric.arn
}

output "autoscaler_disk_encryption_key_arn" {
  value = aws_kms_key.asg_ebs_symmetric.arn
}