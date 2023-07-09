module "resource1" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "${var.path_part}"
  parent_id = "${var.rootpath_id}"
}

module "health-resource" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "health"
  parent_id = "${var.rootpath_id}"
}

# panel token
module "resource17" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "token"
  parent_id = "${module.resource1.resource_id}"
}


module "resource18" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "api"
  parent_id = "${module.resource17.resource_id}"
  http_method = "DELETE,GET,OPTIONS,POST"
}

module "method28" {
    source = "../../aws/apigatewaymethod_proxy"
    apigateway_id = "${var.rest_api_id}"
    http_method = "POST"
    resource_id = "${module.resource18.resource_id}"
    authorization = "CUSTOM"
    authorizer_id = "${var.authorizerprivate_id}"
    connection_id = "${var.connection_id}"
    link = "${var.vpc_link}:3333/token/generate-api"

}


module "resource19" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "private"
  parent_id = "${module.resource17.resource_id}"
  http_method = "DELETE,GET,OPTIONS,POST"
}

module "method30" {
  source = "../../aws/apigatewaymethod_proxy"
  apigateway_id = "${var.rest_api_id}"
  http_method = "DELETE"
  resource_id = "${module.resource19.resource_id}"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizercognito_id}"
  connection_id = "${var.connection_id}"
  link =  "${var.vpc_link}:3333/token/private"

}

module "method32" {
    source = "../../aws/apigatewaymethod_proxy"
    apigateway_id = "${var.rest_api_id}"
    http_method = "POST"
    resource_id = "${module.resource19.resource_id}"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = "${var.authorizercognito_id}"
    connection_id = "${var.connection_id}"
    link =  "${var.vpc_link}:3333/token/generate-private"
}

module "method33" {
    source = "../../aws/apigatewaymethod_proxy"
    apigateway_id = "${var.rest_api_id}"
    http_method = "GET"
    resource_id = "${module.resource19.resource_id}"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = "${var.authorizercognito_id}"
    connection_id = "${var.connection_id}"
    link =  "${var.vpc_link}:3333/token/private"

}

#panel token refresh

module "resource25" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "refresh"
  parent_id = "${module.resource17.resource_id}"
}


module "method34" {
    source = "../../aws/apigatewaymethod_proxy_withoutauthorizer"
    apigateway_id = "${var.rest_api_id}"
    http_method = "POST"
    resource_id = "${module.resource25.resource_id}"
    authorization = "NONE"
    # authorizer_id = "${var.authorizercognito_id}"
    connection_id = "${var.connection_id}"
    link =  "${var.vpc_link}:3333/token/refresh"
}


# panel user
module "resource20" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "user"
  parent_id = "${module.resource1.resource_id}"
}


module "resource21" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "auth"
  parent_id = "${module.resource20.resource_id}"
}



module "resource22" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "{proxy+}"
  parent_id = "${module.resource21.resource_id}"
  http_method = "DELETE,GET,OPTIONS,POST"

}

module "method36" {
  source = "../../aws/apigatewaymethod_proxy"
  apigateway_id = "${var.rest_api_id}"
  http_method = "ANY"
  resource_id = "${module.resource22.resource_id}"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${var.authorizercognito_id}"
  connection_id = "${var.connection_id}"
  link =  "${var.vpc_link}:3333/user/auth/{proxy}"

}



#panel user unauth

module "resource23" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "unauth"
  parent_id = "${module.resource20.resource_id}"
}


module "resource24" {
  source = "../../aws/apigatewayresource"
  rest_api_id = "${var.rest_api_id}"
  path_part = "{proxy+}"
  parent_id = "${module.resource23.resource_id}"

  }





module "method40" {
  source = "../../aws/apigatewaymethod_proxy_withoutauthorizer"
  apigateway_id = "${var.rest_api_id}"
  http_method = "ANY"
  resource_id = "${module.resource24.resource_id}"
  authorization = "NONE"
  connection_id = "${var.connection_id}"
  link =  "${var.vpc_link}:3333/user/unauth/{proxy}"


}



