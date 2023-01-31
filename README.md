# AWS ECR Terraform module

Terraform module which creates ECR repository resources on AWS.

## Usage

```hcl
module "php" {
  source  = "rabiloo/ecr/aws"
  version = "~> 0.2.0"

  name                  = "app-name/php"
  image_tag_mutability  = "MUTABLE"
  input_encryption_type = "AES256"

  protected_tags                 = ["v", "latest"]
  max_image_count                = 20
  untagged_image_expiration_days = 1

  tags = {
    Owner       = "user"
    Service     = "app-name"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.52 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lifecycle_policy"></a> [lifecycle\_policy](#module\_lifecycle\_policy) | ./modules/ecr-lifecycle-policy | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.full](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The unique image name | `string` | n/a | yes |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The encryption type for the repository. Must be one of: `AES256` or `KMS` | `string` | `"AES256"` | no |
| <a name="input_full_access_principals"></a> [full\_access\_principals](#input\_full\_access\_principals) | Principal ARNs to provide with full access to the ECR | `list(string)` | `[]` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The KMS key to use for encryption. Only used if encryption\_type is set to `KMS` | `string` | `""` | no |
| <a name="input_max_image_count"></a> [max\_image\_count](#input\_max\_image\_count) | The maximum number of images to keep in the repository | `number` | `20` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | The list of tags to protect from deletion | `list(string)` | `[]` | no |
| <a name="input_readonly_access_principals"></a> [readonly\_access\_principals](#input\_readonly\_access\_principals) | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Whether to scan the repository on push. Must be one of: `true` or `false` | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to ECR repository resource | `map(string)` | `{}` | no |
| <a name="input_untagged_image_expiration_days"></a> [untagged\_image\_expiration\_days](#input\_untagged\_image\_expiration\_days) | The number of days to keep untagged images in the repository | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_arn"></a> [ecr\_repository\_arn](#output\_ecr\_repository\_arn) | The ECR repository ARN |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | The ECR repository URL |
<!-- END_TF_DOCS -->

## Development

1. Install `terrform`, `tflint`, `terraform-docs` and `make`
2. Using make

```
make help
```

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged. 
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/rabiloo/terraform-aws-ecr/issues).

## License

This project is released under the MIT License.   
Copyright © 2023 [Rabiloo Co., Ltd](https://rabiloo.com)   
Please see [License File](LICENSE) for more information.
