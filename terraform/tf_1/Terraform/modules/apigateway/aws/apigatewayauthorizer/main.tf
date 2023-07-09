resource "aws_api_gateway_authorizer" "ApiGatewayAuthorizer" {
    rest_api_id = "${var.apigateway_id}"
    name = "${var.name}"
    type = "${var.type}"
    authorizer_uri = "${var.authorizer_uri}"
    identity_source = "${var.identity_source}"
    authorizer_result_ttl_in_seconds = 0
}