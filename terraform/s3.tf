resource "aws_s3_bucket" "cluster" {
  bucket        = "goldentooth.cluster"
  force_destroy = false // Don't zap this! It's our state storage.
}
