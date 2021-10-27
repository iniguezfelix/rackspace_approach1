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