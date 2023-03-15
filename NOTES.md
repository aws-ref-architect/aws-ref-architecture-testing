# AWS-deploy Notes

Hosting notes:
- S3 bucket with CloudFront CDN possibly cheapest/simplest approach: Simple yet infinitely scalable.
  - Caveats: Need to ensure access from single specified IP (and one other IP to test).
    - Use Web Application Firewall (WAF) to restrict access to CloudFront Distribution.
- Add `index.html` to Terraform as @file.
  - OPTIONAL: Add trigger from GitHub actions to run `terraform plan && terraform apply` on each commit to `master`.

Terraform notes:
- Local state initially, then S3/DynamoDB.
- List of assets:
  - S3 bucket (`risc-zero-game`)
  - CloudFront CDN distribution (`risc-zero-game`)
  - WAF (`production-risc-zero-game-whitelist-ips`)
  - S3 bucket for Terraform state (`risc-zero-game-tf`)
  - DynamoDB table (`risc-zero-game-tf`)

## Setup Instructions

1. Create new AWS account for best experience.
2. Create new privileged IAM role for setup only (eg. `devops-terraform` in Administrators group).
3. Customize Terraform files to suit your environment. Fork (or submit a PR!!!).
4. Configure and initialize Terraform environment:
  1. Install tfenv: https://github.com/tfutils/tfenv
  2. Install latest terraform release: `tfenv install latest`
  3. Write latest terraform version to `.terraform-version` file in root of directory.
  4. Run `terraform validate && terraform init` to initialize project while checking for syntax errors.
  5. Run `terraform plan` to verify infrastructure changes.
  6. Run `terraform apply` to create your cloud infrastructure assets.
5. Done! Verify your infrastructure and app using `HTTP GET 3.121.56.176`.
