# WIP - Dont forget to enbale dns hostnames and support
resource "aws_vpc" "main" {
  for_each   = var.vpc_cidr_blocks
  cidr_block = each.value

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${each.key}-vpc"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnet_cidrs
  vpc_id            = aws_vpc.main[each.key].id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-${each.key}-private-subnet-a"
  }
}

# WIP -  needed for app1 and app2 VPC due to ALB requirements but not for consumer vpc - NLB may avoid (Lambda limitation)
resource "aws_subnet" "private_b" {
  for_each          = { for k, v in var.private_subnet_cidrs : k => v if k != "consumer" }
  vpc_id            = aws_vpc.main[each.key].id
  cidr_block        = cidrsubnet(var.vpc_cidr_blocks[each.key], 8, 2)
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.project_name}-${each.key}-private-subnet-b"
  }
}



resource "aws_ec2_transit_gateway" "main" {
  description = "${var.project_name}-tgw"

  tags = {
    Name = "${var.project_name}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  for_each           = var.vpc_cidr_blocks
  subnet_ids         = [aws_subnet.private[each.key].id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.main[each.key].id

  tags = {
    Name = "${var.project_name}-${each.key}-tgw-attach"
  }
}





resource "aws_route_table" "private" {
  for_each = var.vpc_cidr_blocks
  vpc_id   = aws_vpc.main[each.key].id

  dynamic "route" {
    for_each = { for k, v in var.vpc_cidr_blocks : k => v if k != each.key }
    content {
      cidr_block         = route.value
      transit_gateway_id = aws_ec2_transit_gateway.main.id
    }
  }

  tags = {
    Name = "${var.project_name}-${each.key}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = var.vpc_cidr_blocks
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}