
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

#Remote Backend on S3 with state locking with a Dynamo db table
terraform {
    backend "s3" {
        encrypt = true 
        bucket = "remote-backend-felix"
        key = "remote.tfstate"
        region = "us-east-1"
        dynamodb_table = "s3-state-lock"
    }
}