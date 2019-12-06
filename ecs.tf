# resource "aws_ecs_cluster" "main" {
#   name = "fargate-study-cluster"
# }

# resource "aws_ecs_task_definition" "main" {
#   family                   = "fargate-study-task-def"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = file("./container_definitions.json")
# }

# resource "aws_ecs_service" "main" {
#   name                              = "fargate-study-service"
#   cluster                           = aws_ecs_cluster.main.arn
#   task_definition                   = aws_ecs_task_definition.main.arn
#   desired_count                     = 1
#   launch_type                       = "FARGATE"
#   platform_version                  = "LATEST"
#   health_check_grace_period_seconds = 60

#   network_configuration {
#     assign_public_ip = false
#     security_groups  = [aws_security_group.api.id]

#     subnets = [
#       aws_subnet.private["private-a"].id,
#       aws_subnet.private["private-c"].id
#     ]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.main.arn
#     container_name   = "nginx"
#     container_port   = 80
#   }

#   lifecycle {
#     ignore_changes = [task_definition]
#   }
# }
