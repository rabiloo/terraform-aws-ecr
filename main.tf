##############################
# ECR Repository
##############################
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge({
    Name = var.name
  }, var.tags)
}

##############################
# ECR lifecycle policy
##############################

locals {
  # Ensure that the protected tag prefixes and patterns are unique
  protected_tags = distinct(var.protected_tags)
}

data "aws_ecr_lifecycle_policy_document" "this" {
  # This rule use 'expire' action but with a very high count_number effectively protects these images
  # from being expired by the lifecycle policy.
  # This rule will not expire images with the specified tags.
  dynamic "rule" {
    for_each = toset(local.protected_tags)

    content {
      priority    = 10 + index(local.protected_tags, rule.value)
      description = "Protect images with tag pattern '${rule.value}' from expiration"
      selection {
        tag_status       = "tagged"
        tag_pattern_list = [rule.value]
        count_type       = "sinceImagePushed"
        count_number     = 999999 # days
        count_unit       = "days"
      }
      action {
        type = "expire"
      }
    }
  }

  # This rule will expire untagged images older than the specified number of days.
  rule {
    priority    = 20 + length(local.protected_tags)
    description = "Expire untagged images older than ${var.untagged_image_expiration_days} days"
    selection {
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_number = var.untagged_image_expiration_days
      count_unit   = "days"
    }
    action {
      type = "expire"
    }
  }

  # This rule will expire images when the total number of images exceeds the specified maximum.
  rule {
    priority    = 30 + length(local.protected_tags)
    description = "Expire images when the total number of images exceeds ${var.max_image_count} images"
    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = var.max_image_count
    }
    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_ecr_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_ecr_lifecycle_policy_document.this.json
}

##############################
# ECR Repository policy
##############################

data "aws_iam_policy_document" "readonly" {
  count = length(var.readonly_access_principals) > 0 ? 1 : 0

  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.readonly_access_principals
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
    ]
  }
}

data "aws_iam_policy_document" "full" {
  count = length(var.full_access_principals) > 0 ? 1 : 0

  statement {
    sid    = "FullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.full_access_principals
    }

    actions = ["ecr:*"]
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents   = data.aws_iam_policy_document.readonly[*].json
  override_policy_documents = data.aws_iam_policy_document.full[*].json
}

resource "aws_ecr_repository_policy" "policy" {
  count = length(var.readonly_access_principals) + length(var.full_access_principals) > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.combined.json
}
