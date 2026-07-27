terraform {
    backend "s3" {
        bucket = "abdulbasid-terraform-state"
        key = "gatus/terraform.tfstate"
        region = "eu-west-2"
        encrypt      = true
        use_lockfile = true
    }
}
    