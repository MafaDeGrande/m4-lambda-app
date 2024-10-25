variable "path" {
  type = string
  description = "Path to the function's deployment package within the local filesystem"
}

variable "key" {
  type = string
  description = "The output of the archive file"
}

variable "bucket_id" {
  type = string
  description = "S3 bucket id"
}
