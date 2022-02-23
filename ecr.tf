resource "aws_ecr_repository" "iac-ecr" {
  name                 = "iac-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

// Memo Service를 ECS에 배포하기 위해 ECR을 만듦 - JeongHyeon Kim 2022.02.23
resource "aws_ecr_repository" "memo-ecr" {
  name                 = "memo-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
