terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# WIP - Need to create a 2 subnets for alb approach
module "networking" {
  source = "../../modules/networking"

  project_name           = var.project_name
  aws_region            = var.aws_region
  vpc_cidr_blocks       = var.vpc_cidr_blocks
  private_subnet_cidrs  = var.private_subnet_cidrs
}

#WIP - Need to modify the response form lambda for each app - (in alb format needed - generic for now) 
module "lambda" {
  source = "../../modules/lambda"

  project_name       = var.project_name
  lambda_functions   = var.lambda_functions
  subnet_ids         = module.networking.lambda_subnet_ids
  security_group_ids = module.networking.lambda_security_group_ids
}

#WIP - Switch to alb as source is lambda
module "alb" {
  source = "../../modules/alb"

  project_name            = var.project_name
  load_balancers         = var.load_balancers
  lambda_function_arns   = module.lambda.lambda_function_arns
  lambda_function_names  = module.lambda.lambda_function_names
  subnet_ids             = module.networking.lambda_subnet_ids
  alb_security_group_ids = module.networking.alb_security_group_ids
  subnet_b_ids           = module.networking.alb_subnet_b_ids
}