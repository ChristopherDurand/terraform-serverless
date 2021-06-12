variable "s3_bucket" {}
variable "domain_name" {}

variable "lambdas" {
  description = "Mapping of lambdas, their routes, methods, and names"
  type = list(object({
    name   = number
    route  = string
    method = string
  }))
}
