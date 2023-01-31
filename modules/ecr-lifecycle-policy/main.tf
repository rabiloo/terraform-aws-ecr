locals {

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

  rules = concat(local.protected_tag_rules, local.untagged_image_rule, local.remove_old_image_rule)
}
