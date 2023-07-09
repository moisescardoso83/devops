resource "aws_api_gateway_resource" "ApiGatewayResource" {
    rest_api_id = "${var.rest_api_id}"
    path_part = "${var.path_part}"
    parent_id = "${var.parent_id}"
}

module "main-method-options" {
    source = "../apigatewaymethod_mock"
    apigateway_id = "${var.rest_api_id}"
    http_method = "OPTIONS"
    http_method_response= "${var.http_method_response}"
    resource_id = aws_api_gateway_resource.ApiGatewayResource.id
}