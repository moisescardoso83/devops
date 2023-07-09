module "resource-health" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "${var.path_part}"
  parent_id = "${var.resource_health_id}"
}

module "method-health" {
    source = "../../aws/apigatewaymethod_proxy_withoutauthorizer"
    apigateway_id = "${var.rest_api_id}"
    http_method = "GET"
    resource_id = "${module.resource-health.resource_id}"
    authorization = "NONE"
    connection_id = "${var.connection_id}"
    link = "${var.vpc_link}:${var.port}"
}
