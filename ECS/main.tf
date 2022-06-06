resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.image_name}"
  image_tag_mutability = "${var.tag_mutability}"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.image_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.image_name}-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.image_name}-container",
      "image": "${aws_ecr_repository.ecr_repository.repository_url}:latest",
      "entryPoint": [],
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name        = "${var.image_name}-ecs"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.image_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 3
  launch_type = "FARGATE"
  network_configuration {
    subnets          = "${var.public_subnet}"
    assign_public_ip = true 
  }
  }