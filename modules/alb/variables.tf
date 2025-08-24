variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "load_balancers" {
  description = "Mapping Load Balancers to create"
  type        = map(number)
}

variable "lambda_function_arns" {
  description = "Mapping Lambda function ARNs"
  type        = map(string)
}

variable "lambda_function_names" {
  description = "Mapping Lambda function names"
  type        = map(string)
}

variable "subnet_ids" {
  description = "Mapping subnet IDs for ALBs"
  type        = map(string)
}

variable "alb_security_group_ids" {
  description = "Mapping security group IDs for ALBs"
  type        = map(string)
}

variable "subnet_b_ids" {
  description = "Mapping second subnet IDs for ALBs"
  type        = map(string)
}

