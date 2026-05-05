terraform {
  backend "s3" {
    bucket       = "kadze-routebox-tfstate-staging"
    key          = "routebox/network/staging/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
