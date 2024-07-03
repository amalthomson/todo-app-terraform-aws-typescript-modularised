variable "lambda_function_name" {
  default = "todo-lambda"
}

variable "lambda_handler" {
  default = "index.handler"
}

variable "lambda_runtime" {
  default = "nodejs20.x"
}