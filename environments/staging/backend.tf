# TODO: fill in bucket, region, and dynamodb_table before first apply, then run:
#   terraform init -reconfigure \
#     -backend-config="bucket=<your-state-bucket>" \
#     -backend-config="key=routebox/network/staging/terraform.tfstate" \
#     -backend-config="region=<your-region>" \
#     -backend-config="dynamodb_table=<your-lock-table>"
terraform {
  backend "s3" {
    bucket         = "TODO-fill-in-state-bucket-name"
    key            = "routebox/network/staging/terraform.tfstate"
    region         = "TODO-fill-in-region"
    dynamodb_table = "TODO-fill-in-lock-table-name"
    encrypt        = true
  }
}
