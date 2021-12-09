### KEY ###

resource "aws_kms_key" "general_purpose_symmetric" {
  deletion_window_in_days = 7
}

### ALIAS ###

resource "aws_kms_alias" "general_purpose_symmetric" {
  name          = "alias/general_purpose_symmetric"
  target_key_id = aws_kms_key.general_purpose_symmetric.key_id
}