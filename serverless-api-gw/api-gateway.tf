resource "aws_api_gateway_http_api" "backend" {
  name                         = "ServerlessBackend"
  protocol_type                = "HTTP"
  description                  = "GenericBackend"
  disable_execute_api_endpoint = false
}
