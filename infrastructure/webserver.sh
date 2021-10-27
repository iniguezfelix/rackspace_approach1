#!/bin/bash
sudo su - root
yum search nginx 
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
sudo echo <h1>Hello AWS servers build on Terraform, connecting to: </h1> <p> `hostname -f` </p> > /usr/share/nginx/html/index.html