resource "aws_api_gateway_rest_api" "ApiGatewayRestApi" {
    name = "${var.name}"
    api_key_source = "HEADER"
    endpoint_configuration {
        types = [
            "REGIONAL"
        ]
    }
}