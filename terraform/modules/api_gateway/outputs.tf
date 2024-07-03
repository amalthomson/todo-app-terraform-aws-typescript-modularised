output "api_url" {
  value = aws_api_gateway_deployment.todo_api_deployment.invoke_url
}

output "create_todo_endpoint" {
  value = "${aws_api_gateway_deployment.todo_api_deployment.invoke_url}/todos"
}

output "get_todo_endpoint" {
  value = "${aws_api_gateway_deployment.todo_api_deployment.invoke_url}/todos/{id}"
}

output "update_todo_endpoint" {
  value = "${aws_api_gateway_deployment.todo_api_deployment.invoke_url}/todos/{id}"
}

output "delete_todo_endpoint" {
  value = "${aws_api_gateway_deployment.todo_api_deployment.invoke_url}/todos/{id}"
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.todo_api.execution_arn
}