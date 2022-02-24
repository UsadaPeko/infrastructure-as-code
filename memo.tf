// 1. ECR
resource "aws_ecr_repository" "memo-ecr" {
  name                 = "memo-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

// 2. ECR Policy
resource "aws_ecr_lifecycle_policy" "memo-ecr-policy" {
  repository = aws_ecr_repository.memo-ecr.name

  policy = jsonencode({
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep image deployed with tag latest",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["latest"],
          "countType": "imageCountMoreThan",
          "countNumber": 1
        },
        "action": {
          "type": "expire"
        }
      },
      {
        "rulePriority": 2,
        "description": "Keep last 2 any images",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 2
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  })
}

// 3. Security Group
resource "aws_security_group" "memo-security-group" {
  name        = "memo-security-group"
  description = "Memo Service Security Group"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "memo-security-group"
  }
}

// 4. ECS Cluster
resource "aws_ecs_cluster" "memo-ecs-cluster" {
  name = "memo-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "memo-ecs-cluster"
  }
}

// 6. ECS Task Definition
resource "aws_ecs_task_definition" "memo-ecs-task-definition" {
  family = "memo-ecs-task-definition"
  container_definitions = jsonencode([
    {
      name      = "memo-ecs-container"
      image     = "${aws_ecr_repository.memo-ecr.repository_url}:latest"
      cpu       = 128 // 1024 Units = 1vCPU로 계산하며, 최솟값은 128 Units 입니다
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])
}
