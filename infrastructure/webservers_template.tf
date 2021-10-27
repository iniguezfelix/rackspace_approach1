resource "aws_launch_configuration" "web_servers" {
  name_prefix = "web_servers"

  image_id = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  key_name = var.keyname_webserver

  security_groups = [aws_security_group.web_servers.id ]
  #associate_public_ip_address = true

  user_data = file("${path.module}/webserver.sh")

  lifecycle {
    create_before_destroy = true
  }
}