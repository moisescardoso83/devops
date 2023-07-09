output "apigateway_id" {
    value = "${aws_api_gateway_rest_api.ApiGatewayRestApi.id}"
}
output "apigateway_root_id" {
    value = "${aws_api_gateway_rest_api.ApiGatewayRestApi.root_resource_id}"
}
output "apigateway_body" {
    value = "${aws_api_gateway_rest_api.ApiGatewayRestApi.body}"
}