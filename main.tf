locals {
  untagged_image_rule = [{
    rulePriority = length(var.protected_tags) + 1
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

  remove_old_image_rule = [{
    rulePriority = length(var.protected_tags) + 2
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

  protected_tag_rules = [
    for index, tagPrefix in tolist(var.protected_tags) :
    {
      rulePriority = tonumber(index) + 1
      description  = "Protects images tagged with ${tagPrefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tagPrefix]
        countType     = "imageCountMoreThan"
        countNumber   = 999999
      }
      action = {
        type = "expire"
      }
    }
  ]
}

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

resource "aws_ecr_lifecycle_policy" "expire_images" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = concat(local.protected_tag_rules, local.untagged_image_rule, local.remove_old_image_rule)
  })
}

data "aws_iam_policy_document" "empty" {}

data "aws_iam_policy_document" "readonly" {
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
  source_json   = length(var.readonly_access_principals) == 0 ? data.aws_iam_policy_document.empty.json : data.aws_iam_policy_document.readonly.json
  override_json = length(var.full_access_principals) == 0 ? data.aws_iam_policy_document.empty.json : data.aws_iam_policy_document.full.json
}

resource "aws_ecr_repository_policy" "policy" {
  count = length(var.readonly_access_principals) + length(var.full_access_principals) > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.combined.json
}
