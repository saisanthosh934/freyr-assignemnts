terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Lambda role
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sequential-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# These permissions are given only this is dev and assignment data
resource "aws_iam_role_policy_attachment" "lambda_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# Lambda  1
resource "aws_lambda_function" "lambda_1" {
  filename         = "lambda1.zip"
  function_name    = "lambda-function-1"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda1.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300

  depends_on = [aws_iam_role_policy_attachment.lambda_full_access]
}

# Lambda  2
resource "aws_lambda_function" "lambda_2" {
  filename         = "lambda2.zip"
  function_name    = "lambda-function-2"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda2.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300

  depends_on = [aws_iam_role_policy_attachment.lambda_full_access]
}

# Lambda  3
resource "aws_lambda_function" "lambda_3" {
  filename         = "lambda3.zip"
  function_name    = "lambda-function-3"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda3.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300

  depends_on = [aws_iam_role_policy_attachment.lambda_full_access]
}