data "terraform_remote_state" "env" {
  backend = "s3"

  config {
    bucket = "levsky-terraform-remote-state"
    key    = "terraform.vpc-1"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

