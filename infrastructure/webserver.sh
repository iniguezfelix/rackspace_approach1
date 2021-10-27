#!/bin/bash
sudo su - root
yum search nginx 
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
sudo echo Hello World! AWS Intances Build Through Terraform, Connecting to: `hostname -f` > /usr/share/nginx/html/index.html