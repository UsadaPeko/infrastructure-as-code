// 1. Security Group
resource "aws_security_group" "iac-security-group" {
  name        = "iac-security-group"
  description = "Allow CoffeeTree inbound traffic"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["39.7.24.115/32"]
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

output "iac-eip" {
  value       = aws_eip.iac-eip.public_ip
  description = "Infrastructure as Code - ec2.tf - EIP"
}

// 5. SNS
resource "aws_sns_topic" "iac-sns-topic" {
  name = "iac-sns-topic"
}
resource "aws_sns_topic_subscription" "iac-sns-topic-subscription" {
  topic_arn = aws_sns_topic.iac-sns-topic.arn
  protocol  = "email"
  endpoint  = "jeonghyeon.rhea@gmail.com;gameboy5141@gmail.com"
}

// 6. CloudWatch
resource "aws_cloudwatch_metric_alarm" "iac-cloudwatch-ec2-cpu-usage" {
  alarm_name                = "cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "0"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  alarm_actions       = [aws_sns_topic.iac-sns-topic.arn]
  ok_actions          = [aws_sns_topic.iac-sns-topic.arn]

  dimensions = {
    InstanceId = aws_instance.iac-ec2.id
  }
}
