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

  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "HTTP"
    from_port        = 443
    to_port          = 443
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

// 4. IAM
data "aws_iam_policy_document" "ecs-task-execution-role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "ecs-staging-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-execution-role.json
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// 5. Application Load Balancer
resource "aws_lb" "memo-alb" {
  name               = "memo-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.memo-security-group.id]
  subnets            = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "memo-alb"
  }
}

// 6. Target Group
resource "aws_lb_target_group" "memo-alb-target-group" {
  name     = "memo-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.iac-vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    timeout             = 2
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

// 7. Application Load Balancer Listener
resource "aws_lb_listener" "memo-alb-listener" {
  load_balancer_arn = aws_lb.memo-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.memo-alb-target-group.arn
  }
}

// 8. ECS Cluster
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

// 9. ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "memo-ecs-cluster-capacity-providers" {
  cluster_name = aws_ecs_cluster.memo-ecs-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// 10. ECS Task Definition
resource "aws_ecs_task_definition" "memo-ecs-task-definition" {
  family = "memo-ecs-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = 256
  memory    = 512
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  container_definitions = jsonencode([
    {
      name      = "memo-ecs-container"
      image     = "${aws_ecr_repository.memo-ecr.repository_url}:60ff002d7bd529810624885e733a9682303f8270"
      cpu       = 256 // 1024 Units = 1vCPU로 계산하며, 최솟값은 128 Units 입니다
                      // 참고: https://dealicious-inc.github.io/2021/05/10/ecs-fargate-benchmark-03.html
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

// 11. ECS Service
resource "aws_ecs_service" "memo-ecs-service" {
  name            = "memo-ecs-service"
  cluster         = aws_ecs_cluster.memo-ecs-cluster.id
  task_definition = aws_ecs_task_definition.memo-ecs-task-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups    = [aws_security_group.memo-security-group.id]
    subnets            = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.memo-alb-target-group.arn
    container_name   = "memo-ecs-container"
    container_port   = 8080
  }
}
