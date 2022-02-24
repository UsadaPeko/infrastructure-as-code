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

// 4. Application Load Balancer
resource "aws_lb" "memo-alb" {
  name               = "memo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.memo-security-group.id]
  subnets            = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]

  enable_deletion_protection = true

  tags = {
    Name = "memo-alb"
  }
}

// 5. Target Group
resource "aws_lb_target_group" "memo-alb-target-group" {
  name     = "memo-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.iac-vpc.id
}

// 6. Application Load Balancer Listener
resource "aws_lb_listener" "memo-alb-listener" {
  load_balancer_arn = aws_lb.memo-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.memo-alb-target-group.arn
  }
}

// 7. ECS Cluster
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

// 8. ECS Task Definition
resource "aws_ecs_task_definition" "memo-ecs-task-definition" {
  family = "memo-ecs-task-definition"
  container_definitions = jsonencode([
    {
      name      = "memo-ecs-container"
      image     = "${aws_ecr_repository.memo-ecr.repository_url}:latest"
      cpu       = 256 // 1024 Units = 1vCPU로 계산하며, 최솟값은 128 Units 입니다
                      // 참고: https://dealicious-inc.github.io/2021/05/10/ecs-fargate-benchmark-03.html
      memory    = 512
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

// 9. ECS Service
resource "aws_ecs_service" "memo-ecs-service" {
  name            = "memo-ecs-service"
  cluster         = aws_ecs_cluster.memo-ecs-cluster.id
  task_definition = aws_ecs_task_definition.memo-ecs-task-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]
    security_groups = [aws_security_group.memo-security-group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.memo-alb-target-group.arn
    container_name   = "memo-container"
    container_port   = 8080
  }
}