data "terraform_remote_state" "env" {
  backend = "s3"

  config {
    bucket = "${var.tf-state-bucket}"
    key    = "${var.tf-state-bucket-key}"
    region = "${var.region}"
  }
}

provider "aws" {
  region = "${var.region}"
}

