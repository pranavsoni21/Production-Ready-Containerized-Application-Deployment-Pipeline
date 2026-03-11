output "vpc_id" {
  value = aws_vpc.app-vpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.app_public_sub[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.app_private_sub[*].id
}