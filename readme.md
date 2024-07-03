# TODO-APP-AWS-TYPESCRIPT-TERRAFORM-MODULARISED

## Project Overview

**ToDo Application**, a serverless solution built using **AWS Lambda**, **API Gateway**, **S3**, **IAM**, **TypeScript**, and **Terraform**. This application allows users to **Create**, **Read**, **Update**, and **Delete** ToDo items. The backend logic is powered by AWS Lambda functions, exposed through API Gateway, and data is stored in an S3 bucket.

## Prerequisites

Ensure you have the following software installed and configured on your local machine with versions mentioned or above:

- **Node** (v18.x.x)
- **npm** (v9.x.x)
- **typescript** (v5.x.x)
- **aws-cli** (v2.x.x) - configured with your AWS account credentials
- **terraform** (v1.x.x)
- **AWS Account** with appropriate permissions

## Setup Instructions

### Clone the Repository
```sh
git clone https://github.com/amalthomson/todo-app-terraform-aws-typescript-modularised.git

```

### Install Dependencies
```sh
cd todo-app
npm install
```

### Build the Project
```sh
npm run build
```

### Package the Lambda Function
```sh
npm run package
```

### Configure AWS CLI
```sh
aws configure
```

### Deploy with Terraform
```sh
cd terraform
terraform init
terraform plan
terraform apply
```

## Local Testing

### Set Up Local Environment

- Install the lambda-local npm package globally or locally in your project
```sh
npm install -g lambda-local
# or
npm install --save-dev lambda-local
```

### Create a Test Event
- Create a JSON file that represents the event object passed to your Lambda function. This file typically includes mock data that the function expects.

### Run the Lambda Function Locally
- Use lambda-local to run your Lambda function locally, passing in the test event file:
```sh
lambda-local -l path/to/compiled/lambdaFunction.js -h handler -e path/to/testEvent.json
```

## Usage
After deployment, the Terraform output will provide the API endpoints. Use these endpoints to interact with the ToDo application:
- Create ToDo: [POST] https://hostname/stagename/todos
- Get ToDo: [GET] https://hostname/stagename/todos/{id}
- Update ToDo: [PUT] https://hostname/stagename/todos/{id}
- Delete ToDo: [DELETE] https://hostname/stagename/todos/{id}

## Cleaning Up
To remove all deployed resources, navigate to the terraform directory and run:
```sh
cd terraform
terraform destroy
```

## Further Expansion
### Add Search Functionality
To add the new functionality, modify the following files.

```sh
# src/controllers/todoController.ts
export async function searchTodos(event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> {
  const searchTerm = event.queryStringParameters?.q || '';
  try {
    const todos = await todoService.searchTodos(searchTerm);
    return {
      statusCode: 200,
      body: JSON.stringify(todos),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to search todos" }),
    };
  }
}
```

```sh
# src/services/todoService.ts
async searchTodos(searchTerm: string): Promise<TodoDto[]> {
  return this.repository.search(searchTerm);
}
```

```sh
# src/repositories/todoRepository.ts
async search(searchTerm: string): Promise<TodoDto[]> {
  const params = {
    Bucket: this.bucketName,
    Prefix: "todos/",
  };

  try {
    const response = await this.s3Client.send(new ListObjectsV2Command(params));
    const contents = response.Contents || [];

    const todos: TodoDto[] = [];
    for (const item of contents) {
      const todoKey = item.Key || "";
      const todoId = todoKey.replace("todos/", "").replace(".json", "");
      const todoData = await this.get(todoId);
      if (todoData && (todoData.title.includes(searchTerm) || todoData.description.includes(searchTerm))) {
        todos.push(todoData);
      }
    }
    return todos;
  } catch (error) {
    console.error("Error searching todos:", error);
    throw error;
  }
}
```

```sh
# terraform/modules/api_gateway/main.tf

# Define API Gateway Resource for Search
resource "aws_api_gateway_resource" "search_resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "search"

# Define API Gateway Method for Search
resource "aws_api_gateway_method" "get_search_method" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.search_resource.id
  http_method   = "GET"
  authorization = "NONE"

# Integration between API Gateway and Lambda for Search
resource "aws_api_gateway_integration" "lambda_integration_search" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.search_resource.id
  http_method = aws_api_gateway_method.get_search_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api_lambda.invoke_arn
}
```
