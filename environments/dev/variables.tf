variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "santhosh-freyr"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr_blocks" {
  description = "VPC CIDR"
  type        = map(string)
  default = {
    consumer = "10.10.0.0/16"
    app1     = "10.20.0.0/16"
    app2     = "10.30.0.0/16"
  }
}

variable "private_subnet_cidrs" {
  description = "Priavte SN CIDR"
  type        = map(string)
  default = {
    consumer = "10.10.1.0/24"
    app1     = "10.20.1.0/24"
    app2     = "10.30.1.0/24"
  }
}

variable "lambda_functions" {
  description = "Map of Lambda functions to create"
  type        = map(number)
  default = {
    consumer = 1
    app1     = 1
    app2     = 1
  }
}

variable "load_balancers" {
  description = "Map of Load Balancers to create"
  type        = map(number)
  default = {
    app1 = 1
    app2 = 1
  }
}

