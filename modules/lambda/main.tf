data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = <<EOF
import json
import urllib3

def handler(event, context):
    if 'test_connectivity' in event:
        
        http = urllib3.PoolManager()
        results = {}
        
        alb_urls = event.get('alb_urls', {})
        for app, url in alb_urls.items():
            try:
                resp = http.request('GET', url)
                results[app] = {'status': resp.status, 'data': resp.data.decode()}
            except Exception as e:
                results[app] = {'error': str(e)}
        
        return {'statusCode': 200, 'body': json.dumps(results)}
    
    
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({'message': 'Hello from Lambda!'})
    }
EOF
    filename = "index.py"
  }
}

resource "aws_iam_role" "lambda_role" {
  for_each = var.lambda_functions
  name     = "${var.project_name}-${each.key}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  for_each   = var.lambda_functions
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  for_each   = var.lambda_functions
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "main" {
  for_each         = var.lambda_functions
  function_name    = "${var.project_name}-${each.key}-lambda"
  role            = aws_iam_role.lambda_role[each.key].arn
  handler         = "index.handler"
  runtime         = "python3.12"
  filename        = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout         = 30

  vpc_config {
    subnet_ids         = [var.subnet_ids[each.key]]
    security_group_ids = [var.security_group_ids[each.key]]
  }

  tags = {
    Name = "${var.project_name}-${each.key}-lambda"
  }
}