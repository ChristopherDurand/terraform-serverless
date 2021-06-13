lambdas = {
  main = {
    memory_size = 128
    runtime = "nodejs14.x"
    handler = "main.handler"
    route_key = "GET /pets"

  }
  secondary = {
    memory_size = 256
    runtime = "nodejs14.x"
    handler = "secondary.handler"
    route_key = "GET /foods"
  }
}
s3_bucket = "terraform-serverless-example-133337"
ver = "1.0.0"