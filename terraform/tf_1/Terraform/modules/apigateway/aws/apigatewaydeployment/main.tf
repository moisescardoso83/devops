resource "aws_api_gateway_deployment" "ApiGatewayDeployment" {
    rest_api_id = "${var.apigateway_id}"
    stage_name = "${var.stagename}"
    triggers = {
      redeployment = sha1(jsonencode("${var.apigateway_body}"))
    }

    lifecycle {
       create_before_destroy = true
   }
}