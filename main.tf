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

module "lifecycle_policy" {
  source = "./modules/ecr-lifecycle-policy"

  protected_tags                 = var.protected_tags
  max_image_count                = var.max_image_count
  untagged_image_expiration_days = var.untagged_image_expiration_days
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = module.lifecycle_policy.policy_json

  depends_on = [
    module.lifecycle_policy,
  ]
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
