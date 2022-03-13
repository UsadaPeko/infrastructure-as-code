// 1. DB Subnet Group
// 어떤 VPC - Subnet에 RDS를 만들 것인가?
resource "aws_db_subnet_group" "iac-db-subnet-group" {
  name       = "iac-db-subnet-group"

  subnet_ids = [
    aws_subnet.iac-subnet-1.id,
    aws_subnet.iac-subnet-2.id
  ]

  tags = {
    Name = "iac-db-subnet-group"
  }
}

// 2. RDS Cluster
resource "aws_rds_cluster" "iac-rds-cluster" {
  cluster_identifier      = "iac-rds-cluster"
  availability_zones      = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  database_name           = "iac-rds"
  master_username         = "rheaso"
  master_password         = "1234qwer"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
}

// 3. RDS Cluster Instance
resource "aws_rds_cluster_instance" "iac-rds-cluster-instance-1" {
  apply_immediately  = true
  publicly_accessible = true
  cluster_identifier = aws_rds_cluster.iac-rds-cluster.id
  identifier         = "iac-rds-cluster-instance-1"
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.iac-rds-cluster.engine
  engine_version     = aws_rds_cluster.iac-rds-cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
}

resource "aws_rds_cluster_instance" "iac-rds-cluster-instance-2" {
  apply_immediately  = true
  publicly_accessible = true
  cluster_identifier = aws_rds_cluster.iac-rds-cluster.id
  identifier         = "iac-rds-cluster-instance-2"
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.iac-rds-cluster.engine
  engine_version     = aws_rds_cluster.iac-rds-cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.iac-db-subnet-group.name
}

// Output
output "iac-rds" {
  value       = aws_rds_cluster.iac-rds-cluster.hosted_zone_id
  description = "Infrastructure as Code - rds.tf"
}
