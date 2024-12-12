resource "aws_lb" "app_lb" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_subnets["0"].id, aws_subnet.public_subnets["2"].id]

  tags = merge(var.tags, { Name = "ProjectALB" })
}
resource "aws_lb_target_group" "web_target_group" {
  name        = "project-web-targets"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id
  target_type = "instance"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, { Name = "WebTargetGroup" })
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
# Attach Webserver 1 to Target Group
resource "aws_lb_target_group_attachment" "webserver_1_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_1.id
  port             = 80
}

# Attach Webserver 3 to Target Group
resource "aws_lb_target_group_attachment" "webserver_3_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_3.id
  port             = 80
}
