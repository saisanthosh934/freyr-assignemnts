output "vpc_ids" {
  description = "Map of VPC IDs"
  value       = module.networking.vpc_ids
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.networking.subnet_ids
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.networking.transit_gateway_id
}

output "lambda_function_arns" {
  description = "Map of Lambda function ARNs"
  value       = module.lambda.lambda_function_arns
}

output "alb_dns_names" {
  description = "Map of ALB DNS names"
  value       = module.alb.alb_dns_names
}