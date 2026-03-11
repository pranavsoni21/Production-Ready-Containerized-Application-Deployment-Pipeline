# Create ECR Repository
resource "aws_ecr_repository" "app-repo" {
  name = "app-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
