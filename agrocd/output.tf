output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = var.aws_region
}

output "ecr_backend_name" {
  value = aws_ecr_repository.backend.name
}

output "ecr_frontend_name" {
  value = aws_ecr_repository.frontend.name
}
