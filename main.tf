resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

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

locals {
  untagged_images_rules = [{
    rulePriority = 20
    description  = "Expire images older than ${var.untagged_image_expiration_days} days"
    selection = {
      tagStatus   = "untagged"
      countType   = "imageCountMoreThan"
      countNumber = var.untagged_image_expiration_days
    }
    action = {
      type = "expire"
    }
  }]
  more_images_rules = [{
    rulePriority = 30
    description  = "Rotate images when reach ${var.max_image_count} images stored",
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.max_image_count
    }
    action = {
      type = "expire"
    }
  }]
  protected_prefix_tags_rules = length(var.protected_tags) == 0 ? [] : [
    {
      rulePriority = 10
      description  = "Protects images tagged with prefix: ${join(", ", var.protected_tags)}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = var.protected_tags
        countType     = "imageCountMoreThan"
        countNumber   = 999999
      }
      action = {
        type = "expire"
      }
    }
  ]
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_ecr_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = jsonencode({ rules = concat(local.untagged_images_rules, local.more_images_rules, local.protected_prefix_tags_rules) })
}

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
