# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "pragmatic-terraform" {
  name                       = "pragmatic-terraform"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id
  ]
}

output "alb_dns_name" {
  value = aws_lb.pragmatic-terraform.dns_name
}

module "http_sg" {
  source    = "./security_group"
  name      = "http-sg"
  vpc_id    = aws_vpc.pragmatic_terraform.id
  port      = 80
  cidr_ipv4 = "0.0.0.0/0"
}

module "https_sg" {
  source    = "./security_group"
  name      = "https-sg"
  vpc_id    = aws_vpc.pragmatic_terraform.id
  port      = 443
  cidr_ipv4 = "0.0.0.0/0"
}

module "http_redirect_sg" {
  source    = "./security_group"
  name      = "http-redirect-sg"
  vpc_id    = aws_vpc.pragmatic_terraform.id
  port      = 8080
  cidr_ipv4 = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "pragmatic-terraform" {
  load_balancer_arn = aws_lb.pragmatic-terraform.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは「HTTP」です"
      status_code  = "200"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "pragmatic_terraform" {
  name                 = "pragmatic-terraform"
  target_type          = "ip"
  vpc_id               = aws_vpc.pragmatic_terraform.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.pragmatic-terraform]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "pragmatic-terraform" {
  listener_arn = aws_lb_listener.pragmatic-terraform.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pragmatic_terraform.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
