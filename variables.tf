variable "name" {
  description = "The unique image name"
  type        = string

  validation {
    condition     = var.name != ""
    error_message = "The image name MUST be not empty."
  }
  validation {
    condition     = var.name == replace(var.name, "/[^a-zA-Z0-9-_\\/]+/", "")
    error_message = "The image name MUST be alphanumeric and can contain dashes, underscores and slash."
  }
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "encryption_type" {
  description = "The encryption type for the repository. Must be one of: `AES256` or `KMS`"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "The KMS key to use for encryption. Only used if encryption_type is set to `KMS`"
  type        = string
  default     = ""
}

variable "scan_on_push" {
  description = "Whether to scan the repository on push. Must be one of: `true` or `false`"
  type        = bool
  default     = false
}

variable "create_ecr_lifecycle_policy" {
  type    = bool
  default = true
}

variable "max_image_count" {
  description = "The maximum number of images to keep in the repository"
  type        = number
  default     = 20
}

variable "untagged_image_expiration_days" {
  description = "The number of days to keep untagged images in the repository"
  type        = number
  default     = 1
}

variable "protected_tags" {
  description = "The list of tags to protect from deletion"
  type        = list(string)
  default     = []
}


variable "full_access_principals" {
  description = "Principal ARNs to provide with full access to the ECR"
  type        = list(string)
  default     = []
}

variable "readonly_access_principals" {
  description = "Principal ARNs to provide with readonly access to the ECR"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to ECR repository resource"
  type        = map(string)
  default     = {}
}
