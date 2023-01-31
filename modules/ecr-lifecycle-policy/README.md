# AWS ECR lifecycle policy Terraform sub-module

Terraform sub-module which creates ECR lifecycle policy.

## Usage

```hcl
module "ecr_lifecycle_policy" {
  source  = "rabiloo/ecr/aws//modules/ecr-lifecycle-policy"
  version = "~> 0.2.0"

  protected_tags                 = ["v", "latest"]
  max_image_count                = 20
  untagged_image_expiration_days = 1
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_image_count"></a> [max\_image\_count](#input\_max\_image\_count) | The maximum number of images to keep in the repository | `number` | `20` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | The list of tags to protect from deletion | `list(string)` | `[]` | no |
| <a name="input_untagged_image_expiration_days"></a> [untagged\_image\_expiration\_days](#input\_untagged\_image\_expiration\_days) | The number of days to keep untagged images in the repository | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | The aws\_ecr\_lifecycle\_policy data |
| <a name="output_policy_json"></a> [policy\_json](#output\_policy\_json) | The aws\_ecr\_lifecycle\_policy data as json |
<!-- END_TF_DOCS -->

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged. 
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/rabiloo/terraform-aws-ecr/issues).

## License

This project is released under the MIT License.   
Copyright © 2023 [Rabiloo Co., Ltd](https://rabiloo.com)   
Please see [License File](LICENSE) for more information.
