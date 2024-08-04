# Provider block to use when configuring Access and Secret key using awscli. See https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html

provider "aws" {
  region = var.AWS_REGION
}

# Provider block to use when declaring Access and Secret key explicitly. 
## WARNING - DO NOT COMMIT THESE KEYS TO THE REPOSITORY

# AWS Provider Configuration
#
# ----------------------------------

# provider "aws" {
#   region     = "${var.AWS_REGION}"
#   access_key = "${var.AWS_ACCESS_KEY}"
#   secret_key = "${var.AWS_SECRET_KEY}"
# }
