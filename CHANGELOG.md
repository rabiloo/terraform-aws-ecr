# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.4.2...master)

### Added

- Nothing

### Changed

- Nothing

### Deprecated

- Nothing

### Removed

- Nothing

### Fixed

- Nothing

### Security

- Nothing

<!-- New Release notes will be placed here automatically -->
## [v0.4.2](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.4.0...v0.4.2) - 2025-07-11

### [Version 0.4.2](https://github.com/rabiloo/terraform-aws-ecr/releases/tag/v0.4.2) 2025-07-11

#### Fix

- Calculate rule priority for ECR lifecycle policy
- Linting workflow

## [v0.4.0](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.3.0...v0.4.0) - 2025-07-10

### [Version 0.4.0](https://github.com/rabiloo/terraform-aws-ecr/releases/tag/v0.4.0) 2025-07-10

#### Add

- Add `force_delete` variable

#### Changed

- Require AWS provider `>= 6.0`
- Variable `protected_tags` will use pattern to protecte the specified image tags
- Use datasource `aws_ecr_lifecycle_policy_document` to generate lifecycle policy

## [v0.3.0](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.2.1...v0.3.0) - 2024-02-22

### Added

- Add `create_ecr_lifecycle_policy` variable

### Removed

- Sub-modules

## [v0.2.1](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.2.0...v0.2.1) - 2023-06-05

### Changed

- Update requirement version or AWS provider to `>= 4.52.0`

## [v0.2.0](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.1.1...v0.2.0) - 2023-01-31

### Added

- Add sub-module `ecr-lifecycle-policy`

### Changed

- Refactor with new AWS provider version

## [v0.1.1](https://github.com/rabiloo/terraform-aws-ecr/compare/v0.1.0...v0.1.1) - 2021-08-26

### Added

- Add Lint action in Github Workflow
- Add Makefile
- Add documents for inputs and outputs

## v0.1.0 - 2021-08-10

### Added

- Initial Release
