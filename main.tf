/**
 * A Terraform module that creates a tagged S3 bucket and an IAM user/key with access to the bucket
 */


# we need a service account user
resource "aws_iam_user" "user" {
  name = "srv_${var.bucket_name}"
}

# generate keys for service account user
resource "aws_iam_access_key" "user_keys" {
  user = "${aws_iam_user.user.name}"
}

# create an s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucket_name}"
  force_destroy = "true"

  # versioning {
  #   enabled = "${var.versioning}"
  # }

  tags = {
    team          = "${var.tag_team}"
    application   = "${var.tag_application}"
    environment   = "${var.tag_environment}"
    contact-email = "${var.tag_contact-email}"
    creator      = "${var.tag_creator}"
    project       = "${var.tag_project}"
  }

    # lifecycle_rule {
    #   id                                     = "auto-delete-incomplete-after-x-days"
    #   prefix                                 = ""
    #   enabled                                = "${var.multipart_delete}"
    #   abort_incomplete_multipart_upload_days = "${var.multipart_days}"
    # }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = "${aws_s3_bucket.bucket.id}"
  versioning_configuration {
    status = "${var.versioning}"
  }
}

# resource "aws_s3_bucket_lifecycle_configuration" "aws_s3_lifecycle" {
#   bucket = "${aws_s3_bucket.bucket.id}"
#   rule {
#     id                                     = "auto-delete-incomplete-after-x-days"    
#     abort_incomplete_multipart_upload_days = "${var.multipart_days}"
#     status                                 = "${var.multipart_delete}"
#   }
# }

# grant user access to the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.user.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
EOF
}
