output "apigatewaymethod_id" {
    value = "${aws_api_gateway_method.ApiGatewayMethod.id}"
}
output "apigatewaymethod_httpmethod" {
    value = "${aws_api_gateway_method.ApiGatewayMethod.http_method}"
}