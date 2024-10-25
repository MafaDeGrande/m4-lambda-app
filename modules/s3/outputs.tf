output "s3_bucket" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "s3_key" {
  value = aws_s3_object.lambda_hello_world.key
}

output "source_code_hash" {
  value = data.archive_file.lambda_hello_world.output_base64sha256
}
