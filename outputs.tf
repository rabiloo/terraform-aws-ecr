output "ecr_repository_url" {
  description = "The ECR repository URL"
  value       = aws_ecr_repository.this.repository_url
}

output "ecr_repository_arn" {
  description = "The ECR repository ARN"
  value       = aws_ecr_repository.this.arn
}
