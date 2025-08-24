resource "aws_lb" "main" {
  for_each           = var.load_balancers
  name               = "${var.project_name}-${each.key}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_ids[each.key]]
  subnets            = [var.subnet_ids[each.key], var.subnet_b_ids[each.key]]

  tags = {
    Name = "${var.project_name}-${each.key}-alb"
  }
}

resource "aws_lb_target_group" "lambda" {
  for_each    = var.load_balancers
  name        = "${var.project_name}-${each.key}-tg"
  target_type = "lambda"

  tags = {
    Name = "${var.project_name}-${each.key}-tg"
  }
}

resource "aws_lb_listener" "main" {
  for_each          = var.load_balancers
  load_balancer_arn = aws_lb.main[each.key].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda[each.key].arn
  }
}

resource "aws_lb_target_group_attachment" "lambda" {
  for_each         = var.load_balancers
  target_group_arn = aws_lb_target_group.lambda[each.key].arn
  target_id        = var.lambda_function_arns[each.key]
  depends_on       = [aws_lambda_permission.alb]
}

resource "aws_lambda_permission" "alb" {
  for_each      = var.load_balancers
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_names[each.key]
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda[each.key].arn
}