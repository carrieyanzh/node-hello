resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Name     = "newrelic"
          apiKey   = var.newrelic_license_key
          endpoint = "https://log-api.eu.newrelic.com/log/v1"
        }
        # secretOptions = [ # for json kind of secrets 
        #   {
        #     name      = "apiKey"
        #     valueFrom = var.newrelic_secret_arn
        #   }
        # ]
      }
    },
    {
      name      = "log_router"
      image     = "533243300146.dkr.ecr.eu-north-1.amazonaws.com/newrelic/logging-firelens-fluentbit:1.17.1"
      essential = true
      firelensConfiguration = {
        type = "fluentbit"
        options = {
          enable-ecs-log-metadata = "true"
        }
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.app_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "firelens"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  depends_on = [var.role_attachment_id]
}
resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.app_name}-log-group"
  }
}