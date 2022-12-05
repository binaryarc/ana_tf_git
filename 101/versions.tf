provider "aws" {
  profile = "mfa"
  region  = "ap-northeast-2" # Asia Pacific (Seoul) region
  version = "~> 4.0"
}

terraform {
  backend "s3" {
    bucket = "ana-service-log-bucket22"
    profile = "mfa"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "TerraformStateLock"
    # depends_on = [aws_dynamodb_table.terraform_state_lock]
  }
}