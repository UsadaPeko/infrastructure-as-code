// 1. ECR
resource "aws_ecr_repository" "iac-ecr" {
  name                 = "iac-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

// 2. ECR Policy
resource "aws_ecr_lifecycle_policy" "iac-ecr-policy" {
  repository = aws_ecr_repository.iac-ecr.name

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
resource "aws_security_group" "iac-security-group" {
  name        = "iac-security-group"
  description = "iac Service Security Group"
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
    Name = "iac-security-group"
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
resource "aws_lb" "iac-alb" {
  name               = "iac-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.iac-security-group.id]
  subnets            = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "iac-alb"
  }
}

// 6. Target Group
resource "aws_lb_target_group" "iac-alb-target-group" {
  name     = "iac-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.iac-vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

// 7. Application Load Balancer Listener
resource "aws_lb_listener" "iac-alb-listener" {
  load_balancer_arn = aws_lb.iac-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.iac-alb-target-group.arn
  }
}

// 8. ECS Cluster
resource "aws_ecs_cluster" "iac-ecs-cluster" {
  name = "iac-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "iac-ecs-cluster"
  }
}

// 9. ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "iac-ecs-cluster-capacity-providers" {
  cluster_name = aws_ecs_cluster.iac-ecs-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// 10. ECS Task Definition
resource "aws_ecs_task_definition" "iac-ecs-task-definition" {
  family = "iac-ecs-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = 256
  iacry    = 512
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  container_definitions = jsonencode([
    {
      name      = "iac-ecs-container"
      image     = "${aws_ecr_repository.iac-ecr.repository_url}:60ff002d7bd529810624885e733a9682303f8270"
      cpu       = 256 // 1024 Units = 1vCPU로 계산하며, 최솟값은 128 Units 입니다
                      // 참고: https://dealicious-inc.github.io/2021/05/10/ecs-fargate-benchmark-03.html
      iacry    = 512
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
resource "aws_ecs_service" "iac-ecs-service" {
  name            = "iac-ecs-service"
  cluster         = aws_ecs_cluster.iac-ecs-cluster.id
  task_definition = aws_ecs_task_definition.iac-ecs-task-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups    = [aws_security_group.iac-security-group.id]
    subnets            = [aws_subnet.iac-subnet-1.id, aws_subnet.iac-subnet-2.id]
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.iac-alb-target-group.arn
    container_name   = "iac-ecs-container"
    container_port   = 8080
  }
  
  timeouts {
    delete = "10s"
  }
}

// 12. Route53
resource "aws_route53_record" "iac-domain" {
  zone_id = aws_route53_zone.rhea-so.zone_id
  name    = "iac.rhea-so.com"
  type    = "A"

  alias {
    name                   = aws_lb.iac-alb.dns_name
    zone_id                = aws_lb.iac-alb.zone_id
    evaluate_target_health = true
  }
}

// 13. Auto Scaling Group
resource "aws_appautoscaling_target" "iac-ecs-autoscaling-target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.iac-ecs-cluster.name}/${aws_ecs_service.iac-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "iac-ecs-autoscaling-policy-iacry" {
  name               = "iacry-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.iac-ecs-autoscaling-target.resource_id
  scalable_dimension = aws_appautoscaling_target.iac-ecs-autoscaling-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.iac-ecs-autoscaling-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageiacryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "iac-ecs-autoscaling-policy-cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.iac-ecs-autoscaling-target.resource_id
  scalable_dimension = aws_appautoscaling_target.iac-ecs-autoscaling-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.iac-ecs-autoscaling-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 30
  }
}
