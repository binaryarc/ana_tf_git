resource "aws_ecr_repository" "ana" {
  name                 = "anaconda"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}