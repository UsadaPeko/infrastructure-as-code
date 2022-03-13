resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  availability_zones      = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  database_name           = "mydb"
  master_username         = "rhea-so"
  master_password         = "1234qwer"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

resource "aws_rds_cluster_instance" "test1" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.default.id
  identifier         = "test1"
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
  publicly_accessible = true
}

resource "aws_rds_cluster_instance" "test2" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.default.id
  identifier         = "test2"
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
  publicly_accessible = true
}

// Output
output "iac-rds" {
  value       = aws_rds_cluster.default.hosted_zone_id
  description = "Infrastructure as Code - rds.tf"
}
