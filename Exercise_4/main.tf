terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }

  #  backend "s3" {
  #    bucket = "<YOUR_S3_BUCKET_FOR_TERRAFORM_STATE_FILE_GOES_HERE>" # Generate a random string in https://randomkeygen.com and convert it to lowercase in https://convertcase.net/
  #    key    = "terraform-state-file-for-exercise-1"
  #    region = "us-east-1" # Ensure bucket exists in the selected region in the tenant/is created in tenant beforehand ; pending replace value for variables.tf file reference
  #  }
}
