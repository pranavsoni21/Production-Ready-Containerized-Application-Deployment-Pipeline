output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "container_sg_id" {
  value = aws_security_group.container-sg.id
}

