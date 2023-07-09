output "name" {
  value = "${aws_lambda_function.lambda.function_name}"
}

output "arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "version" {
  value = "${aws_lambda_function.lambda.version}"
}

output "apigatewayauthorizer_id" {
    value = "${module.authorizer_testlambda.apigatewayauthorizer_id}"
}