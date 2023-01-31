variable "protected_tags" {
  description = "The list of tags to protect from deletion"
  type        = list(string)
  default     = []
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
