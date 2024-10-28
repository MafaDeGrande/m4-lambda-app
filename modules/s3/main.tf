resource "aws_s3_object" "lambda_hello_world" {
  bucket = var.bucket_id 
  key = var.key
  source = "${var.path}/${var.key}"
  etag = filemd5("${var.path}/${var.key}")
}
