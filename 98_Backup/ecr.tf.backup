resource "aws_ecr_repository" "iac-ecr" {
  name                 = "iac-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
