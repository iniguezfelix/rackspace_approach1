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

#Restrict S3 Public Access
resource "aws_s3_bucket_public_access_block" "statefile_private" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#DynamoDB Table
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "s3-state-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
