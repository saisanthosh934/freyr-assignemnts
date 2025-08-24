resource "aws_security_group" "lambda" {
  for_each    = var.vpc_cidr_blocks
  name_prefix = "${var.project_name}-${each.key}-lambda-"
  vpc_id      = aws_vpc.main[each.key].id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = values(var.vpc_cidr_blocks)
  }

  tags = {
    Name = "${var.project_name}-${each.key}-lambda-sg"
  }
}

resource "aws_security_group" "alb" {
  for_each    = { for k, v in var.vpc_cidr_blocks : k => v if k != "consumer" }
  name_prefix = "${var.project_name}-${each.key}-alb-"
  vpc_id      = aws_vpc.main[each.key].id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["consumer"]]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${each.key}-alb-sg"
  }
}