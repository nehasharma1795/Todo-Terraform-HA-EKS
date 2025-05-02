output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}
# ✅ Make sure you have this data source defined somewhere:
# data "aws_caller_identity" "current" {}

output "aws_region" {
  value = var.aws_region
}
# ✅ Ensure var.aws_region is declared in your variables.tf.


# ✅ Check that my_eks_cluster.main is defined correctly.

output "ecr_backend_name" {
  value = aws_ecr_repository.backend.name
}
# ✅ Confirm that aws_ecr_repository.backend exists.

output "ecr_frontend_name" {
  value = aws_ecr_repository.frontend.name
}
# ✅ Confirm that aws_ecr_repository.frontend exists.
