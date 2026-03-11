# Create ECS cluster
resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Create ECS task definition
resource "aws_ecs_task_definition" "app-task" {
  family                = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = var.network_mode
  cpu = var.ecs_task_cpu
  memory = var.ecs_task_memory
  execution_role_arn = var.iam_role_arn
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "app-service" {
  name = "app-service"
  cluster = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  availability_zone_rebalancing = "ENABLED"
  desired_count = var.desired_count
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "app-container"
    container_port = var.container_port
  }
  network_configuration {
    security_groups = var.security_groups_id
    subnets = var.private_subnets
  }
}