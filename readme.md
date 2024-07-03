# TODO-APP-TERRAFORM-AWS-TYPESCRIPT-MODULARISED

## Project Overview

**ToDo Application**, a serverless solution built using **AWS Lambda**, **API Gateway**, **S3**, **IAM**, **TypeScript**, and **Terraform**. This application allows users to **Create**, **Read**, **Update**, and **Delete** ToDo items. The backend logic is powered by AWS Lambda functions, exposed through API Gateway, and data is stored in an S3 bucket.

## Prerequisites

Ensure you have the following software installed and configured on your local machine with versions mentioned or above:

- **Node** (v18.x.x)
- **npm** (v9.x.x)
- **TypeScript** (v5.x.x)
- **AWS CLI** (v2.x.x) - configured with your AWS account credentials
- **Terraform** (v1.x.x)
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
or
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

