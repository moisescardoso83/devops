resource "aws_api_gateway_method" "ApiGatewayMethod" {
    rest_api_id = "${var.apigateway_id}"
    resource_id = "${var.resource_id}"
    http_method = "${var.http_method}"
    authorization = "${var.authorization}"
    authorizer_id = "${var.authorizer_id}"
    api_key_required = false
    request_parameters = {
        "method.request.path.proxy" = true
    }
}


resource "aws_api_gateway_integration" "apiIntegration" {
    rest_api_id = "${var.apigateway_id}"
    resource_id = "${var.resource_id}"
    http_method = "${var.http_method}"
    type = "HTTP_PROXY"
    uri = "${var.link}"
    integration_http_method = "${var.http_method}"
    connection_type = "VPC_LINK"
    connection_id = "${var.connection_id}"

    request_parameters = {
      "integration.request.path.proxy" = "method.request.path.proxy"
   }
    depends_on = [
      aws_api_gateway_method.ApiGatewayMethod
  ]
}



resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = "${var.apigateway_id}"
    resource_id   = "${var.resource_id}"
    http_method   = "${aws_api_gateway_method.ApiGatewayMethod.http_method}"
    status_code   = 200
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin" = false
    }

    depends_on = [
      aws_api_gateway_method.ApiGatewayMethod,
      aws_api_gateway_integration.apiIntegration
    ]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
   rest_api_id = "${var.apigateway_id}"
   resource_id = "${var.resource_id}"
   http_method = "${var.http_method}"
   status_code = 200
   response_templates = {
       "application/json" = ""
   }
   response_parameters = {
       "method.response.header.Access-Control-Allow-Origin" = "'*'"
   }

   depends_on = [
     aws_api_gateway_method.ApiGatewayMethod,
     aws_api_gateway_integration.apiIntegration,
     aws_api_gateway_method_response.options_200
   ]
}