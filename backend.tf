# Terraform backend file stored in s3
terraform {
    backend "s3" {
        bucket = "equifax-terraform"
        key    = "terraform.tfstate"
        region = "us-east-1"
  }
}


