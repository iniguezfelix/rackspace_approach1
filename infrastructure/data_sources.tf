#Data Source to get lastest AWS Linux AMI
data "aws_ami" "server_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}