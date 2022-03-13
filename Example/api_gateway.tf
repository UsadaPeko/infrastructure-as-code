resource "aws_api_gateway_rest_api" "api" {
  name = "api-gateway"
  description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://google.com/{proxy}"
 
  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}
