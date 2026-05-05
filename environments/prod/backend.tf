terraform {
  backend "s3" {
    bucket       = "kadze-routebox-tfstate-prod"
    key          = "routebox/network/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
