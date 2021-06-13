variable "s3_bucket" {}
variable "lambdas" {
  type = map(object({
    memory_size = number
    runtime = string
    handler = string
    route_key = string
  }))
}
variable "ver" {}


