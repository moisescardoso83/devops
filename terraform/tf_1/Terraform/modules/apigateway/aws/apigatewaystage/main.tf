resource "aws_api_gateway_stage" "ApiGatewayStage" {
    stage_name = "${var.name}"
    deployment_id = "${var.deployment_id}"
    rest_api_id = "${var.rest_api_id}"
    cache_cluster_enabled = false
    cache_cluster_size = "0.5"
    xray_tracing_enabled = false
}

