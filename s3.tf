# S3 resources

resource "random_id" "hash" {
  byte_length = 4
}

resource "aws_s3_bucket" "data" {
  bucket = "emr-bucket-${random_id.hash.hex}"
}

# Upload objects to S3 bucket

resource "aws_s3_bucket_object" "py" {
  bucket     = "${aws_s3_bucket.data.bucket}"
  key        = "demo/word_count_emr.py"
  source     = "./word_count_emr.py"
  etag       = "${filemd5("./word_count_emr.py")}"
}

resource "aws_s3_bucket_object" "input" {
  bucket = "${aws_s3_bucket.data.bucket}"
  key    = "demo/input.txt"
  source = "./input.txt"
}

# Example step.json file for awsCLI usage
data "template_file" "step" {
  template = "${file("step.json.tpl")}"
  vars = {
    bucket = "${aws_s3_bucket.data.bucket}"
  }
}

resource "aws_s3_bucket_object" "step" {
  bucket  = "${aws_s3_bucket.data.bucket}"
  key     = "demo/step.json"
  content = "${data.template_file.step.rendered}"
}
