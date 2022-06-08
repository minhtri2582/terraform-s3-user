//name of the bucket
variable "bucket_name" {}

//enable versioning
variable "versioning" {
  default = false
}

//environment
variable "tag_environment" {}

//team
variable "tag_team" {}

//application
variable "tag_application" {}

//contact-email
variable "tag_contact-email" {}

//customer
variable "tag_customer" {}

// creator
variable "tag_creator" {}

// project       
variable "tag_project" {}       

//incomplete multipart upload deletion
variable "multipart_delete" {
  default = true
}

variable "multipart_days" {
  default = 3
}
