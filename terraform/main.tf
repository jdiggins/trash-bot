provider "aws" {
  region = "us-east-1"
}

variable "function_name" {
  default = "trash-bot"
}

variable "handler" {
  default = "handler.lambda_handler"
}

variable "runtime" {
  default = "python3.8"
}

variable "zip_name" {
  default = "../src/function.zip"
}

resource "aws_lambda_function" "trash_bot_lambda" {
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.zip_name
  function_name    = var.function_name
  source_code_hash = filebase64sha256("../src/function.zip")
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec"
  path = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "every_thurs_fri" {
    name = "check-trashbot-thu-fri"
    description = "Fires 9 & 20 THU and FRI"
    schedule_expression = "cron(0 9,20 ? * THU,FRI *)"
}

resource "aws_cloudwatch_event_target" "check_trash_every_thurs_fri" {
    rule = aws_cloudwatch_event_rule.every_thurs_fri.name
    target_id = "trash-bot"
    arn = aws_lambda_function.trash_bot_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_trashbot" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.trash_bot_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_thurs_fri.arn
}
