#KMS for S3 Bucket Encryption
resource "aws_kms_key" "kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

#S3 bucket for remote State file
resource "aws_s3_bucket" "state_bucket" {
    bucket = "remote-backend-felix"
    acl = "private"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.kms_key.arn
                sse_algorithm     = "aws:kms"
            }
        }
    }
}