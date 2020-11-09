terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------
# variables の設定
# ------------------------------------------------
variable "vpc_id" {
  default = "****"
}

variable "cluster_name" {
  description = "example"
  type        = string
  default     = "example"
}

variable "service_name" {
  description = "example"
  type        = string
  default     = "example"
}

# ------------------------------------------------
# 既存 Resource の指定
# ------------------------------------------------
data "aws_vpc" "example" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.example.id

  filter {
    name   = "tag:Name"
    values = ["rf-sandbox-***-private0-sb", " rf-sandbox-***--private0-sb"]
  }
}

# ------------------------------------------------
# 新規 Resource の作成
# ------------------------------------------------
resource "aws_ecs_cluster" "example" {
  name = var.cluster_name
}

resource "aws_ecs_service" "example" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.example.arn
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets = data.aws_subnet_ids.all.ids
  }
}

resource "aws_ecs_task_definition" "example" {
  family                   = "terratest"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  container_definitions    = <<-JSON
    [
      {
        "image": "terraterst-example",
        "name": "terratest",
        "networkMode": "awsvpc"
      }
    ]
JSON
}

resource "aws_iam_role" "execution" {
  name               = "${var.cluster_name}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.assume-execution.json
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "assume-execution" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
