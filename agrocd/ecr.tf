resource "aws_ecr_repository" "backend" {
  name = var.ecr_backend_name
}

resource "aws_ecr_repository" "frontend" {
  name = var.ecr_frontend_name
}
