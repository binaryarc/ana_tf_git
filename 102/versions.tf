provider "aws" {
  profile = "mfa"
  region  = "ap-northeast-2" # Asia Pacific (Seoul) region
  version = "~> 4.0"
}

data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "ana-service-log-bucket22"
    key    = "terraform.tfstate"
    profile = "mfa"
    region = "ap-northeast-2"
  }
}