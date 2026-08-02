terraform {

 backend "s3" {

   bucket = "abdulbasid-terraform-state"

   key = "bootstrap/terraform.tfstate"

   region = "eu-west-2"

 }

}