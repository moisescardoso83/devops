module "main-resource" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "${var.path_part}"
  parent_id = "${var.rootpath_id}"
}

module "resource-client" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "client"
  parent_id = "${module.main-resource.resource_id}"
}

module "client-proxy" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "{proxy+}"
  parent_id = "${module.resource-client.resource_id}"
  http_method_response = "DELETE,GET,OPTIONS,POST"
}


module "method-client" {
    source = "../../aws/apigatewaymethod_proxy"
    apigateway_id = "${var.rest_api_id}"
    http_method = "ANY"
    resource_id = "${module.client-proxy.resource_id}"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = "${var.authorizercognito_id}"
    connection_id = "${var.connection_id}"
    link = "${var.vpc_link}:${var.port}/client/{proxy}"

}



module "proxy-proxy" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "{proxy+}"
  parent_id = "${module.main-resource.resource_id}"
}


module "method-proxy" {
    source = "../../aws/apigatewaymethod_proxy"
    apigateway_id = "${var.rest_api_id}"
    http_method = "ANY"
    resource_id = "${module.proxy-proxy.resource_id}"
    authorization = "CUSTOM"
    authorizer_id = "${var.authorizer_id}"
    connection_id = "${var.connection_id}"
    link = "${var.vpc_link}:${var.port}/api/{proxy}"

}