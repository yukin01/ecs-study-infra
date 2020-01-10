resource "aws_lb_target_group" "argocd" {
  name     = "${var.prefix}-eks-argocd"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener_rule" "argocd" {
  listener_arn = aws_lb_listener.eks_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd.arn
  }

  condition {
    field = "host-header"
    values = [var.argocd_domain_name]
  }
}

resource "aws_autoscaling_attachment" "argocd" {
  autoscaling_group_name = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
  alb_target_group_arn   = aws_lb_target_group.argocd.arn
}
