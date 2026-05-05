data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_letter = ["a", "b", "c"]

  public_subnet_map = {
    for i in [0, 1, 2] : tostring(i) => {
      cidr   = var.public_subnet_cidrs[i]
      suffix = local.az_letter[i]
    }
  }

  private_subnet_map = {
    for i in [0, 1, 2] : tostring(i) => {
      cidr   = var.private_subnet_cidrs[i]
      suffix = local.az_letter[i]
    }
  }
}
