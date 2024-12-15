# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "pragmatic_terraform" {
  name = "pragmatic-terraform"

  tags = {
    Name = "pragmatic-terraform"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "pragmatic_terraform" {
  family                   = "pragmatic-terraform"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn

  tags = {
    Name = "pragmatic-terraform"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "pragmatic_terraform" {
  name                              = "pragmatic-terraform"
  cluster                           = aws_ecs_cluster.pragmatic_terraform.arn
  task_definition                   = aws_ecs_task_definition.pragmatic_terraform.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [
      module.nginx_sg.security_group_id
    ]

    subnets = [
      aws_subnet.private_0.id,
      aws_subnet.private_1.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pragmatic_terraform.arn
    container_name   = "nginx"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  tags = {
    Name = "pragmatic-terraform"
  }
}

module "nginx_sg" {
  source    = "./security_group"
  name      = "nginx-sg"
  vpc_id    = aws_vpc.pragmatic_terraform.id
  port      = 80
  cidr_ipv4 = aws_vpc.pragmatic_terraform.cidr_block
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "/ecs/pragmatic-terraform"
  retention_in_days = 7
}

# ESCタスク実行ロールのポリシー
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source     = "./iam_role"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}
