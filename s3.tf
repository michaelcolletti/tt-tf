resource "aws_s3_bucket" "monitor" {
  bucket = "mon-log-bucket"
  acl    = "private"

  tags = {
    Name        = "Monitoring Data"
    Environment = "Prod"
  }
versioning {
    enabled = true
  }
}
