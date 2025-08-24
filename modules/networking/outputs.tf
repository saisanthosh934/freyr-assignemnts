output "vpc_ids" {
  description = "Mapping VPC IDs"
  value       = { for k, v in aws_vpc.main : k => v.id }
}

output "subnet_ids" {
  description = "Mapping subnet IDs"
  value       = { for k, v in aws_subnet.private : k => v.id }
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "lambda_subnet_ids" {
  description = "Mapping subnet IDs"
  value       = { for k, v in aws_subnet.private : k => v.id }
}

output "lambda_security_group_ids" {
  description = "Mapping Lambda security group IDs"
  value       = { for k, v in aws_security_group.lambda : k => v.id }
}

output "alb_security_group_ids" {
  description = "Mapping ALB security group IDs"
  value       = { for k, v in aws_security_group.alb : k => v.id }
}

output "alb_subnet_b_ids" {
  description = "Mapping second subnet IDs for ALBs"
  value       = { for k, v in aws_subnet.private_b : k => v.id }
}