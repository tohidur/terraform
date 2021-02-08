provider "aws" {
  region = var.region
  shared_credentials_file = var.shared_aws_creds_file
  profile = "aws_terraform"
  assume_role {
    role_arn = "arn:aws:iam:<account>:role/Terraform"
  }
}
