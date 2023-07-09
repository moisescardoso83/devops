resource "aws_api_gateway_method" "ApiGatewayMethod" {
    rest_api_id = "${var.apigateway_id}"
    resource_id = "${var.resource_id}"
    http_method = "${var.http_method}"
    authorization = "${var.authorization}"
    api_key_required = false

}


resource "aws_api_gateway_integration" "Integration" {
    rest_api_id = "${var.apigateway_id}"
    resource_id = "${var.resource_id}"
    http_method = "${var.http_method}"
    type = "MOCK"
    request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
    depends_on = [
      aws_api_gateway_method.ApiGatewayMethod
  ]
}


resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = "${var.apigateway_id}"
    resource_id   = "${var.resource_id}"
    http_method   = "${var.http_method}"
    status_code   = 200
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = false,
        "method.response.header.Access-Control-Allow-Methods" = false,
        "method.response.header.Access-Control-Allow-Origin" = false
    }
    depends_on = [
      aws_api_gateway_method.ApiGatewayMethod,
      aws_api_gateway_integration.Integration
  ]
}


resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = "${var.apigateway_id}"
    resource_id   = "${var.resource_id}"
    http_method   = "${var.http_method}"
    status_code   = 200
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,x-access-token,x-pagination-token,x-filter,x-page-size,x-page,x-frame-options'",
        "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
  response_templates = {
     "application/json" = ""
  }

    depends_on = [
      aws_api_gateway_method.ApiGatewayMethod,
      aws_api_gateway_integration.Integration,
      aws_api_gateway_method_response.options_200
  ]
}
