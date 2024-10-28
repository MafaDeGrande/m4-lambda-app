output "s3_key" {
  value = aws_s3_object.lambda_hello_world.key
}

output "source_code_hash" {
  value = aws_s3_object.lambda_hello_world.checksum_sha256
}
