output "lambda_function_arns" {
  description = "mapping lambda ARNs"
  value       = { for k, v in aws_lambda_function.main : k => v.arn }
}

output "lambda_function_names" {
  description = "mapping function names"
  value       = { for k, v in aws_lambda_function.main : k => v.function_name }
}

output "lambda_invoke_arns" {
  description = "mapping lambda invoke ARNs"
  value       = { for k, v in aws_lambda_function.main : k => v.invoke_arn }
}