// 1. API Gateway
resource "aws_api_gateway_rest_api" "iac-api-gateway" {
  name = "iac-api-gateway"
  description = "Proxy to handle requests to our API"
}

// 2. Set up address
# /google
resource "aws_api_gateway_resource" "iac-api-gateway-resource-google" {
  rest_api_id = "${aws_api_gateway_rest_api.iac-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.iac-api-gateway.root_resource_id}"
  path_part   = "google"
}

# /google/enter
resource "aws_api_gateway_resource" "iac-api-gateway-resource-google-enter" {
  rest_api_id = "${aws_api_gateway_rest_api.iac-api-gateway.id}"
  parent_id   = "${aws_api_gateway_resource.iac-api-gateway-resource-google.id}"
  path_part   = "enter"
}

# /google/enter is GET
resource "aws_api_gateway_method" "iac-api-gateway-method-google-enter" {
  rest_api_id   = "${aws_api_gateway_rest_api.iac-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.iac-api-gateway-resource-google-enter.id}"
  http_method   = "GET"
  authorization = "NONE"
}

# /google/enter is proxy into google.com
resource "aws_api_gateway_integration" "iac-api-gateway-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.iac-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.iac-api-gateway-resource-google-enter.id}"
  http_method = "${aws_api_gateway_method.iac-api-gateway-method-google-enter.http_method}"
  integration_http_method = "GET" # GET으로 Proxy
  type                    = "HTTP_PROXY"
  uri                     = "http://google.com"
}
