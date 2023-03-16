resource "aws_s3_bucket" "log_bucket" {
  bucket = "risc-zero-game-logs"
  acl    = "log-delivery-write"

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}
