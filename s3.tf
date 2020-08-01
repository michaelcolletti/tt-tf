resource "aws_s3_bucket" "monitor" {
  bucket = "mon-log-bucket"
  acl    = "private"

  tags = {
    Name        = "Monitoring and Log Data"
    Environment = "Prod"
  }
versioning {
    enabled = false
  }
}
resource "aws_s3_bucket" "templates" {
  bucket = "tt-template-bucket"
  acl    = "private"

  tags = {
    Name        = "Templates and Stacks"
    Environment = "Prod"
  }
versioning {
    enabled = true
  }
}
