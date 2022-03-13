// 1. API Gateway for HTTP
resource "aws_apigatewayv2_api" "iac-api-gateway-http" {
  name = "iac-api-gateway-http"
  protocol_type = "HTTP"
}
