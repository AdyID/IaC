resource "aws_ecr_repository" "this" {
  name                 = "${var.ecr_name}-${var.env}"
  image_tag_mutability = "MUTABLE"

  tags = var.tags
}
