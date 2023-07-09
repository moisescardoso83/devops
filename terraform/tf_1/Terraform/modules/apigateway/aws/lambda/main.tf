module "authorizer_testlambda" {
    source = "../apigatewayauthorizer"
    apigateway_id = "${var.rest_api_id}"
    name = "${var.authorizer_name}"
    type = "TOKEN"
    authtype= "custom"
    authorizer_uri = aws_lambda_function.lambda.invoke_arn
    identity_source = "${var.identity_source}"
}



resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:054875283858:${var.rest_api_id}/*/*"
}

resource "aws_lambda_function" "lambda" {
  filename      = "${var.file_name}"
  function_name = "${var.function_name}"
  role          = "${var.role}"
  handler       = "${var.handler}"
  memory_size      = 1028
  publish = true
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${var.source_code_hash}"
  runtime = "${var.runtime}"
  environment {
    variables = {
      PANEL_URL = "${var.panel_url}"
      POLICY_RESOURCE = "${var.policy}"
    }

 }
   vpc_config {
     security_group_ids = [
       "sg-0f99d378d005276fc",
     ]
     subnet_ids = [
       "subnet-021ea1aa2fa8b65f4",
       "subnet-06fbd8a6449eb0a58",
       "subnet-08856138ea62a669b",
       "subnet-0bebee963edf690fa",
       "subnet-0c85ceaf32585f8fe",
       "subnet-0ec1c175d33db84db",
     ]

   }

}