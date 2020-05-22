# create s3 bucket to store bootstrap script
resource "aws_s3_bucket" "s3_httpd" {
  bucket = "equifax-assignment"
  acl = "private"
  
  tags = {
    Name        = "httpd"
  }
}

resource "aws_s3_bucket_object" "httpd" {
  bucket = "${aws_s3_bucket.s3_httpd.id}"
  key    = "httpd.sh"
  source = "./httpd.sh"
}