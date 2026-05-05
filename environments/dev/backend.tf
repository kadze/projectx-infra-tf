terraform {
  backend "s3" {
    bucket       = "kadze-routebox-tfstate-dev"
    key          = "routebox/network/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
