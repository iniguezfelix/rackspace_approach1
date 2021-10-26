terraform {
    backend "s3" {
        bucket = "remote-backend-felix"
        key = "remote.tfstate"
        region = "us-east-1"
        dynamodb_table = "s3-state-lock"
    }
}