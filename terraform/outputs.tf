output "api_endpoint" {
  value = "${aws_api_gateway_stage.rest_api.invoke_url}${aws_api_gateway_resource.api_demo.path}"
}
