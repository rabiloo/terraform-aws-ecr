output "policy" {
  description = "The aws_ecr_lifecycle_policy data"
  value = {
    rules = local.rules
  }
}

output "policy_json" {
  description = "The aws_ecr_lifecycle_policy data as json"
  value       = jsonencode({ rules = local.rules })
}
