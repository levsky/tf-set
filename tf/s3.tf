# Create S3 bucket for terraform state
resource "aws_s3_bucket" "kops-s3-bucket" {
  bucket = "${var.kops-s3-bucket}"
  acl    = "private"

  tags = {
    Name    = "kops-s3-bucket"
    env     = "admin"
  }
}

resource "aws_s3_bucket_public_access_block" "kops-3-bucket" {
  bucket = "${aws_s3_bucket.kops-s3-bucket.id}"

  block_public_acls   = true
  block_public_policy = true
}