terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "backend" {
  for_each      = var.lambdas
  function_name = each.key
  s3_bucket     = var.s3_bucket
  s3_key        = "${var.ver}/${each.key}.zip"
  memory_size   = each.value.memory_size
  handler       = each.value.handler
  runtime       = each.value.runtime
  role          = aws_iam_role.lambda_exec.arn
}


resource "aws_apigatewayv2_api" "backend" {
  name                         = "ServerlessBackend"
  protocol_type                = "HTTP"
  description                  = "GenericBackend"
  disable_execute_api_endpoint = false
}

resource "aws_apigatewayv2_integration" "backend" {
  for_each = aws_lambda_function.backend
  api_id   = aws_apigatewayv2_api.backend.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = each.value.invoke_arn
}

resource "aws_apigatewayv2_route" "backend" {
  for_each = var.lambdas
  api_id   = aws_apigatewayv2_api.backend.id

  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.backend[each.key].id}"
}

resource "aws_apigatewayv2_stage" "backend" {
  api_id = aws_apigatewayv2_api.backend.id
  name   = "backend-stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_deployment" "backend" {
  api_id      = aws_apigatewayv2_api.backend.id
  description = "Example deployment"

  triggers = {
    redeployment = sha1(join(",", flatten(list(
      jsonencode(aws_apigatewayv2_integration.backend[*]),
      jsonencode(aws_apigatewayv2_route.backend[*]),
    ))))
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lambda_permission" "allow_apigw" {
  for_each      = aws_lambda_function.backend
  statement_id  = "AllowApiGatewayExecuteLambdas"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.backend.execution_arn}/*/*/*"
}

resource "aws_iam_role" "lambda_exec" {
  name               = "serverless_example_lambda"
  assume_role_policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  }
  POLICY
}
