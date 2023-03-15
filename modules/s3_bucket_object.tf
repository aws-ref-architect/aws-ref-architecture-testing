resource "aws_s3_object" "game" {
  bucket = aws_s3_bucket.var.bucket_name.id
  acl    = "public-read"
  source = "../app/index.html"
  etag   = filemd5("../app/index.html")
}
