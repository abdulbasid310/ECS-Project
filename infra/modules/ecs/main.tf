resource "aws_ecs_cluster" "gatus_cluster" {
  name = "gatus_cluster"
}

resource "aws_ecs_task_definition" "gatus_definition" {
  family                   = "gatus_definition"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      name  = "gatus_container"
      image = var.app_image
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.gatus_log_group.name
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "gatus"
        }
      }
  }])
}

# ECS fargate used for serverless computing and automatic scaling
resource "aws_ecs_service" "gatus_service" {
  name            = "gatus_service"
  cluster         = aws_ecs_cluster.gatus_cluster.id
  task_definition = aws_ecs_task_definition.gatus_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "gatus_container"
    container_port   = var.app_port
  }


}

resource "aws_appautoscaling_target" "ecs_target" {

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity

  resource_id        = "service/${aws_ecs_cluster.gatus_cluster.name}/${aws_ecs_service.gatus_service.name}"

  scalable_dimension = "ecs:service:DesiredCount"

  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scaling" {

  name = "cpu-scaling-policy"

  policy_type = "TargetTrackingScaling"

  resource_id = aws_appautoscaling_target.ecs_target.resource_id

  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension

  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {

    target_value = 70

    predefined_metric_specification {

      predefined_metric_type = "ECSServiceAverageCPUUtilization"

    }

    scale_in_cooldown = 60

    scale_out_cooldown = 60
  }
}

# Allows traffic to the cluster from the alb only
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow traffic to the cluster from the alb only"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ingress" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = var.alb_sg

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "gatus_log_group" {
  name              = "gatus_log_group"
  retention_in_days = 30

  tags = {
    name = "gatus-log-group"
  }
}






