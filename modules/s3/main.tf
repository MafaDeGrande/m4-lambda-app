data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = var.path
  output_path = "${var.path}/${var.key}"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = var.bucket_id 
  key = var.key
  source = data.archive_file.lambda_hello_world.output_path
  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}
