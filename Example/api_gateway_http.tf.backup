// 1. API Gateway for HTTP
resource "aws_apigatewayv2_api" "iac-api-gateway-http" {
  name = "iac-api-gateway-http"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "iac-api-gateway-http-integration" {
  api_id           = aws_apigatewayv2_api.iac-api-gateway-http.id
  integration_type = "HTTP_PROXY"

  integration_method = "GET"
  integration_uri    = "https://google.com"
}

resource "aws_apigatewayv2_route" "iac-api-gateway-http-route" {
  api_id    = aws_apigatewayv2_api.iac-api-gateway-http.id
  route_key = "GET /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.iac-api-gateway-http-integration.id}"
}

// Output
output "iac-api-gateway-http-endpoint" {
  value       =  aws_apigatewayv2_api.iac-api-gateway-http.api_endpoint
  description = "Infrastructure as Code - api_gateway_http.tf - API Gateway Endpoint"
}
