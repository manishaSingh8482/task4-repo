output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns" {
  value = aws_lb.this.dns_name
}
