#ALB DNS Hostname to access the Web Servers
output "alb_dns_name" {
  value = aws_alb.web_alb.dns_name
}