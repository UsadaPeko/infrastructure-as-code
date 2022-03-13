// 1. VPC
resource "aws_vpc" "iac-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "iac-vpc"
  }
}

// 2. Internet Gateway
resource "aws_internet_gateway" "iac-igw" {
  vpc_id = aws_vpc.iac-vpc.id

  tags = {
    Name = "iac-igw"
  }
}

// 3. Subnet
resource "aws_subnet" "iac-subnet-1" {
  vpc_id     = aws_vpc.iac-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "iac-subnet-1"
  }
}
resource "aws_subnet" "iac-subnet-2" {
  vpc_id     = aws_vpc.iac-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "iac-subnet-2"
  }
}

// 4. Routing Table
resource "aws_route_table" "iac-routing-table" {
  vpc_id = aws_vpc.iac-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-igw.id
  }

  tags = {
    Name = "iac-routing-table"
  }
}

// 5. Routing Table Association (Subnet + Routing Table)
resource "aws_route_table_association" "iac-routing-table-association-1" {
  subnet_id      = aws_subnet.iac-subnet-1.id
  route_table_id = aws_route_table.iac-routing-table.id
}
resource "aws_route_table_association" "iac-routing-table-association-2" {
  subnet_id      = aws_subnet.iac-subnet-2.id
  route_table_id = aws_route_table.iac-routing-table.id
}

// 1. Security Group
resource "aws_security_group" "iac-security-group" {
  name        = "iac-security-group"
  description = "Allow Home inbound traffic"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["121.161.240.241/32"]
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

// 2. EC2
resource "aws_instance" "iac-ec2" {
   ami           = "ami-0454bb2fefc7de534"
   instance_type = "t3.nano"
   key_name = "Home"
   subnet_id = aws_subnet.iac-subnet-1.id
   vpc_security_group_ids = [aws_security_group.iac-security-group.id]

   tags = {
     Name = "iac-ec2"
   }
 }

// 3. EIP
resource "aws_eip" "iac-eip" {
  instance = aws_instance.iac-ec2.id
  vpc      = true

   tags = {
     Name = "iac-eip"
   }
}

// 4. Route53
resource "aws_route53_record" "iac-route53" {
  zone_id = aws_route53_zone.rhea-so.zone_id
  name    = "ec2.rhea-so.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.iac-eip.public_ip]
}

// 5. SNS
resource "aws_sns_topic" "iac-sns-topic" {
  name = "iac-sns-topic"
}

resource "aws_sns_topic_subscription" "iac-sns-topic-subscription" {
  topic_arn = aws_sns_topic.iac-sns-topic.arn
  protocol  = "email"
  endpoint  = "jeonghyeon.rhea@gmail.com"
}

// 6. CloudWatch
resource "aws_cloudwatch_metric_alarm" "iac-cloudwatch-ec2-cpu-usage" {
  alarm_name                = "iac-cloudwatch-ec2-cpu-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" // seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors iac-ec2 cpu usage"
  insufficient_data_actions = []

  alarm_actions       = [aws_sns_topic.iac-sns-topic.arn]
  ok_actions          = [aws_sns_topic.iac-sns-topic.arn]

  dimensions = {
    InstanceId = aws_instance.iac-ec2.id
  }
}

// Output
output "iac-eip" {
  value       = aws_eip.iac-eip.public_ip
  description = "Infrastructure as Code - ec2.tf - EIP"
}


# // 1. DB Subnet Group
# // 어떤 VPC - Subnet에 RDS를 만들 것인가?
# resource "aws_db_subnet_group" "iac-db-subnet-group" {
#   name       = "iac-db-subnet-group"

#   subnet_ids = [
#     aws_subnet.iac-subnet-1.id,
#     aws_subnet.iac-subnet-2.id
#   ]

#   tags = {
#     Name = "iac-db-subnet-group"
#   }
# }

# // 2. RDS Cluster
# resource "aws_rds_cluster" "iac-rds-cluster" {
#   cluster_identifier      = "iac-rds-cluster"
#   availability_zones      = ["ap-northeast-2a", "ap-northeast-2c"]
#   database_name           = "iac-rds"
#   master_username         = "rheaso"
#   master_password         = "1234qwer"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
#   db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
# }

# // 3. RDS Cluster Instance
# resource "aws_rds_cluster_instance" "iac-rds-cluster-instance-1" {
#   apply_immediately  = true
#   publicly_accessible = true
#   cluster_identifier = aws_rds_cluster.iac-rds-cluster.id
#   identifier         = "iac-rds-cluster-instance-1"
#   instance_class     = "db.t3.small"
#   engine             = aws_rds_cluster.iac-rds-cluster.engine
#   engine_version     = aws_rds_cluster.iac-rds-cluster.engine_version
#   db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
# }
# resource "aws_rds_cluster_instance" "iac-rds-cluster-instance-2" {
#   apply_immediately  = true
#   publicly_accessible = true
#   cluster_identifier = aws_rds_cluster.iac-rds-cluster.id
#   identifier         = "iac-rds-cluster-instance-2"
#   instance_class     = "db.t3.small"
#   engine             = aws_rds_cluster.iac-rds-cluster.engine
#   engine_version     = aws_rds_cluster.iac-rds-cluster.engine_version
#   db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
# }

# // Output
# output "iac-rds" {
#   value       = aws_rds_cluster.iac-rds-cluster.hosted_zone_id
#   description = "Infrastructure as Code - rds.tf"
# }
