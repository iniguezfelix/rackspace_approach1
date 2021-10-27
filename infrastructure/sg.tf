#Security Group for Web Servers and HTTP Traffic
resource "aws_security_group" "web_servers" {
  name        = "web_servers"
  description = "Allow HTTP Inbound Connections for WEB Servers"
  vpc_id = aws_vpc.vpc_approach1.id


  dynamic "ingress" {
    for_each = var.webserver_ports
    content  {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [aws_security_group.bastion.id]
    }

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    //cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_http.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    //security_groups = [aws_security_group.alb_http.id]
  }

  tags = {
    Name = "Allow HTTP Security Group"
  }

}

#Security Group for SSH Access to Bastion Server in Public Network
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH Inbound Connections fro the internet"
  vpc_id = aws_vpc.vpc_approach1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH Bastion Security Group"
  }

}
#SB for ELB to allow HTTP traffic to the instances
resource "aws_security_group" "alb_http" {
  name        = "alb_http"
  description = "Allow HTTP traffic to instances through Application Load Balancer ONLY"
  vpc_id = aws_vpc.vpc_approach1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group HTTP"
  }
}