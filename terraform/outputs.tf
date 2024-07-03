output "api_url" {
  value = module.api_gateway.api_url
}

output "create_todo_endpoint" {
  value = module.api_gateway.create_todo_endpoint
}

output "get_todo_endpoint" {
  value = module.api_gateway.get_todo_endpoint
}

output "update_todo_endpoint" {
  value = module.api_gateway.update_todo_endpoint
}

output "delete_todo_endpoint" {
  value = module.api_gateway.delete_todo_endpoint
}