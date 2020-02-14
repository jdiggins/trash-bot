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

variable "scheduler_cron_expr" {
  default = "cron(0 9,20 ? * THU,FRI *)"
}

resource "aws_lambda_function" "trash_bot_lambda" {
  role             = aws_iam_role.trashbot_lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.zip_name
  function_name    = var.function_name
  source_code_hash = filebase64sha256("../src/function.zip")
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs, aws_iam_role_policy_attachment.lambda_SMS]
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "allow_SNS_for_SMS" {
  name = "allow_SNS_for_SMS"
  path = "/"
  description = "IAM policy for sending SMS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
      "Effect": "Allow",
      "Action": "SNS:Publish",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.trashbot_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_SMS" {
  role = aws_iam_role.trashbot_lambda_role.name
  policy_arn = aws_iam_policy.allow_SNS_for_SMS.arn
}

resource "aws_iam_role" "trashbot_lambda_role" {
  name = "trashbot_lambda_role"
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
    schedule_expression = var.scheduler_cron_expr
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



