resource "aws_alb" "gatus_alb" {
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_alb_target_group" "gatus_target" {
  name        = "gatus-target"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = "30"
    timeout             = 5
  }
}

#HTTP listener redirects all traffic to HTTPS
resource "aws_alb_listener" "gatus_listener" {
  load_balancer_arn = aws_alb.gatus_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.gatus_alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.gatus_target.arn
    type             = "forward"
  }
}

# ALB security group allows all traffic from the internet
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "security group for the load balancer"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}