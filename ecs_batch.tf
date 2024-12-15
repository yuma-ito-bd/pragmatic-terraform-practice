resource "aws_ecs_task_definition" "pragmatic_terraform_batch" {
  family                   = "pragmatic-terraform-batch"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions_batch.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name              = "/ecs-scheduled-tasks/pragmatic-terraform"
  retention_in_days = 7
}

module "ecs_events_role" {
  source     = "./iam_role"
  name       = "ecs-events-role"
  identifier = "events.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
resource "aws_cloudwatch_event_rule" "pragmatic_terraform_batch" {
  name                = "pragmatic-terraform-batch"
  description         = "Run the ECS task definition on a schedule"
  schedule_expression = "cron(*/2 * * * ? *)"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target
resource "aws_cloudwatch_event_target" "pragmatic_terraform_batch" {
  target_id = "pragmatic-terraform-batch"
  rule      = aws_cloudwatch_event_rule.pragmatic_terraform_batch.name
  role_arn  = module.ecs_events_role.iam_role_arn
  arn       = aws_ecs_cluster.pragmatic_terraform.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    platform_version    = "1.4.0"
    task_definition_arn = aws_ecs_task_definition.pragmatic_terraform_batch.arn

    network_configuration {
      assign_public_ip = false
      subnets          = [aws_subnet.private_0.id]
    }
  }
}
