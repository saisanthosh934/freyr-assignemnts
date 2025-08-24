variable "project_name" {
  description = "Project name"
  type        = string
}

variable "lambda_functions" {
  description = "mapping lambdas"
  type        = map(number)
}

variable "subnet_ids" {
  description = "mapping Subnets"
  type        = map(string)
}

variable "security_group_ids" {
  description = "Mapping SG's"
  type        = map(string)
}