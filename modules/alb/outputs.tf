output "alb_dns_names" {
  description = "Map of ALB DNS names"
  value       = { for k, v in aws_lb.main : k => v.dns_name }
}

output "alb_arns" {
  description = "Map of ALB ARNs"
  value       = { for k, v in aws_lb.main : k => v.arn }
}