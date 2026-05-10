variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod). Prefixes repository names."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "services" {
  type        = list(string)
  description = "Service names for which ECR repositories are created."
  default     = ["ops-console", "shipments-api", "tracking-events", "route-optimizer"]
}

variable "cost_center" {
  type        = string
  description = "Cost-allocation tag value."
  default     = "platform"
}
