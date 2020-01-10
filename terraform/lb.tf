# resource "aws_lb" "main" {
#   name                       = "fargate-study-lb"
#   load_balancer_type         = "application"
#   internal                   = false
#   idle_timeout               = 60
#   enable_deletion_protection = false

#   subnets = [
#     aws_subnet.public["public-a"].id,
#     aws_subnet.public["public-c"].id
#   ]

#   security_groups = [
#     aws_security_group.lb.id
#   ]
# }

# resource "aws_lb_target_group" "main" {
#   name        = "fargate-study-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main.id

#   health_check {
#     path                = "/"
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     timeout             = 5
#     interval            = 30
#     matcher             = 200
#     port                = "traffic-port"
#     protocol            = "HTTP"
#   }

#   depends_on = [aws_lb.main]
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
# }
