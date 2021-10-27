resource "aws_launch_configuration" "web_servers" {
  name_prefix = "web_servers"

  image_id = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  key_name = "web-server"

  security_groups = [aws_security_group.web_servers.id ]
  #associate_public_ip_address = true

  user_data = <<-EOF
		#!/bin/bash
        sudo su - root
        yum search nginx 
        amazon-linux-extras install nginx1 -y
        systemctl start nginx
        systemctl enable nginx
        sudo echo Hello AWS servers build on Terraform, connecting to: `hostname -f` > /usr/share/nginx/html/index.html
        
	    EOF

  lifecycle {
    create_before_destroy = true
  }
}