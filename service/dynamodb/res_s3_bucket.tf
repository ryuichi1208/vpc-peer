resource "aws_s3_bucket" "tfstate-storage" {
  bucket = "tfstate-${var.app_name}"
  acl    = "private"
  region = "ap-northeast-1"

  versioning {
    enabled = true
  }
}
